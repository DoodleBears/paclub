import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paclub/backend/api/user_api.dart';
import 'package:paclub/constants/log_message.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/utils/app_response.dart';

/// [文件说明]
/// - 提供用户所有信息的 Repository(仓库), 之所以是 `extends GetxService`
/// - 是因为 Authentication 是永恒存在于 User 使用期间的, 即整个 App 存活期间的，直到app完全退出
/// - 之所以 FirebaseAuthRepository 要存活在整个生命周期中
/// - 是因为我们当用户操作时需要处理到用户的信息（可能是浏览记录或是其他数据），所以要时刻检查用户状态
///
/// [使用场景]
/// - 在任意一个页面，无论登陆与否, 都需要用到
/// - [没登录时] : 用来登录
/// - [登录后用]
///   - 用来登出
///   - 存储用户的资料
///   - 点赞, 等各种跟User有关的操作前需要获取uid
class FirebaseAuthRepository extends GetxController {
  // 之所以 FirebaseAuthRepository 需要是 GetxService，
  // 是因为需要长时间存在（监听User State），不能用 static （class function）的形式调用
  // 所以依赖它的 API 也不行
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId: kIsWeb ? '161942683104-4pg008m87p5vviu7p271qu01rvevg33q' : null,
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user = FirebaseAuth.instance.currentUser;
  // GoogleSignInAccount? _currentUser;

  /// [取得用户类] 回传 User instance（Firebase）
  User? get user {
    return _user;
  }

  /// [初始化 Service] 绑定监听 user 和 connectivity 状态
  @override
  void onInit() async {
    logger3.i('初始化 FirebaseAuthRepository' +
        (useAuthEmulator ? '(useAuthEmulator)' : ''));

    if (useAuthEmulator) {
      logger.w('设定 FirebaseAuth 为 useAuthEmulator');
      await _auth.useAuthEmulator(localhost, authPort);
    }
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   _currentUser = account;
    //   if (_currentUser != null) {
    //     logger.i('Web 登录成功');
    //   } else {
    //     logger.e('Web 登录失败');
    //   }
    // });
    // _googleSignIn.signInSilently();

    // 一旦 _auth 状态改变, _user 就会被重新赋值

    _auth.authStateChanges().listen((User? user) {
      _user = user;

      // 一旦用户丢失在线状态或未验证邮箱
      // 则强制用户返回主页(比如重设密码时，会强制下线所有终端上的该用户账号)
      if (user == null) {
        logger.d('Firebase 检测到用户状态为: 未登录');
      } else {
        AppConstants.uuid = user.uid;
        if (user.displayName != null) {
          AppConstants.userName = user.displayName!;
        }

        // 之所以不在此处统一设置检测用户在线，自动跳转主页是因为可能存在用户在其他页面登录的情况
        // 此外，不应该在 Repository 有页面交互的代码
        logger.d('Firebase 检测到用户状态为: 登录\n用户ID: ' + user.uid);

        if (user.emailVerified == false) {
          // 当登录用户没有验证邮箱时
        } else {}
      }
    });
    super.onInit();
  }

  /// [结束 Service] 关闭监听 user 状态
  @override
  void onClose() {
    logger.w('关闭 FirebaseAuthRepository' +
        (useFirestoreEmulator ? '(useAuthEmulator)' : ''));
    super.onClose();
  }

  /// [重载用户] 当用户登陆或切换状态时候需要用到
  Future<void> reload() async {
    try {
      await user!.reload();
    } on FirebaseException catch (e) {
      logger3.w(e.code);
    } catch (e) {
      throw e;
    }
  }

  /// [检测是否登陆]
  bool isLogin() {
    if (user == null) {
      return false;
    }
    return true;
  }

  /// [Email 注册功能] —— 回传字串结果
  Future<AppResponse> registerWithEmail(
      String email, String password, String name, String bio) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      logger.d('账号注册通过: $email');

      await user!.updateDisplayName(name);
      logger.d('更新账号信息成功, name是: $name');
      AppConstants.userName = name;
      final UserApi userApi = Get.find<UserApi>();

      AppResponse appResponse = await userApi.addUser(
          userModel: UserModel(
              uid: user!.uid, displayName: name, email: email, bio: bio));

      if (appResponse.data == null) {
        logger3.e('添加用户信息到 firestore/user 失败');
        return AppResponse(kAddUserFailedError, null);
      }
      logger.d('添加用户信息到 firestore/user 成功');

      return AppResponse('Register success', email);
    } on FirebaseAuthException catch (e) {
      AppResponse appResponse =
          AppResponse(e.code, null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    } catch (e) {
      AppResponse appResponse =
          AppResponse('Unknown Exception', null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    }
  }

  Future<AppResponse> sendEmailVerification() async {
    if (isEmailVerified()) {
      return AppResponse('email_already_verified', null);
    }
    try {
      await user?.sendEmailVerification();
      logger3.d('发送 Eamil 成功');
      return AppResponse('send_verify_email_successed', true);
    } on FirebaseAuthException catch (e) {
      AppResponse appResponse =
          AppResponse(e.code, null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    } catch (e) {
      AppResponse appResponse =
          AppResponse('Unknown Exception', null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    }
  }

  /// [检查用户 Email 认证]
  bool isEmailVerified() {
    reload(); // 用户认证邮箱后 authStateChanges().listen 并不会监听到，需要自己 reload
    logger3.d('邮箱认证状态: ' + (user!.emailVerified ? '已认证' : '未认证'));

    return user!.emailVerified;
  }

  /// [Email 登录功能] —— 回传字串结果
  Future<AppResponse> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // 使用 Firebase 提供的[用Email登陆]方法
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // 添加用户到 Firestore
      final User user = userCredential.user!;

      final UserApi userApi = Get.find<UserApi>();
      AppResponse appResponse = await userApi.addUser(
        userModel: UserModel(
            uid: user.uid,
            displayName: user.displayName!,
            avatarURL: '',
            email: email,
            bio: ''),
      );

      if (appResponse.data == null) {
        logger3.e('添加用户信息到 firestore/user 失败');
        return AppResponse(kAddUserFailedError, null);
      }
      logger.d('添加用户信息到 firestore/user 成功');

      return AppResponse(kSignInSuccessed, email);
    } on FirebaseAuthException catch (e) {
      // FirebaseAuth 的异常，如密码错误等
      AppResponse appResponse =
          AppResponse(e.code, null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    } on PlatformException catch (e) {
      // 像是联网错误
      AppResponse appResponse =
          AppResponse(e.code, null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    }
  }

  /// [使用Google账号登录功能] —— 回传Google的 User认证 instance
  Future<AppResponse> signInWithGoogle() async {
    try {
      logger.i('开始 Google Sign In');
      // 调用Google登陆认证, 弹窗并等待用户选择账号
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // 等待用户完整Google授权的response, 如果用户取消, 则 googleUser 为 null

      if (googleUser == null) {
        AppResponse appResponse = AppResponse(kSignInCanceledError, null);
        logger3.w(appResponse.toString());
        return appResponse;
      }
      logger.i('开始 Google Sign In 验证');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // 验证认证成功, 用 googleAuth 创建一个证书
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 使用该证书登陆 (可以是 Twitter, Google 等证书)
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User user = userCredential.user!;
      final UserApi userApi = Get.find<UserApi>();
      AppResponse appResponse = await userApi.addUser(
          userModel: UserModel(
              uid: user.uid,
              displayName: user.displayName!,
              avatarURL: user.photoURL ?? '',
              email: user.email!,
              bio: ''));

      if (appResponse.data == null) {
        logger3.e('添加用户信息到 firestore/user 失败');
        return AppResponse(kAddUserFailedError, null);
      }
      logger.d('添加用户信息到 firestore/user 成功');

      return AppResponse(kSignInSuccessed, userCredential);
    } on FirebaseAuthException catch (e) {
      // TODO: 解决如果账号已经用 email 注册登陆后, 想用同一个 email 对应的 google account 登陆的情况
      AppResponse appResponse =
          AppResponse(e.code, null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    } on PlatformException catch (e) {
      AppResponse appResponse =
          AppResponse(e.code, null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    }
  }

  /// [登出功能]
  Future<AppResponse> signOut() async {
    try {
      String uid = user!.uid;
      await _auth.signOut();
      logger3.d('登出用户ID: ' + uid);
      return AppResponse(kSignOutSuccessed, uid);
    } catch (e) {
      logger3.w('Sign out 失败');
      return AppResponse(kSignOutFailedError, null, e.runtimeType.toString());
    }
  }
}
