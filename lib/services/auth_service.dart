import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paclub/modules/login/login_controller.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/loading_dialog.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/toast.dart';

// 提供用户所有信息的 Service, 之所以是 `extends GetxService`
/// 是因为, 这是永恒存在于User使用期间的, 即整个App的使用期间的
/// 无论是登录, 还是没有登录, 都需要用到他
/// 【没登录时】：用它登录
/// 【登录后用】：它会存住用户的资料, 以便登出, 点赞, 等各种跟User有关的操作
class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User> _user = Rx<User>(null);
  // 获得 user
  User get user => _auth.currentUser;

  // 绑定 firebase 的 _auth, 以获得自动检测 User 状态的功能
  @override
  void onInit() {
    // 一旦 _auth 状态改变, _user 就会被重新赋值
    logger.i('初始化 AuthService');
    _user.bindStream(_auth.authStateChanges());
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        logger.w('Firebase 检测到用户状态为: 未登录');
      } else {
        logger.w('用户登录: ' + (user == null ? 'null' : user.uid));
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 authService');
    super.onClose();
  }

  //* 判断是否登录
  bool isLogin({bool notify = true, bool jump = false}) {
    if (user == null) {
      // 是否跳出提示
      if (notify) toast('请先登录');
      // 是否要强制用户跳转到登录页面
      if (jump) {
        Get.until((route) => false);
        Get.toNamed(Routes.AUTH);
      }
      return false;
    } else {
      return true;
    }
  }

  //* Email 注册功能
  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      if (e.code == 'weak-password') toast('weak password');
      if (e.code == 'invalid-email') toast('email form isn\'t right');
      if (e.code == 'email-already-in-use') toast('account already exists');
      if (e.code == 'too-many-requests') {
        toast('you have try too many times\nplease wait 30 secs');
      }
      if (e.code == 'unknown') toast('check your internet connection');
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  //* Email 登录功能
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      logger.d('Firebase Exception 错误码:' + e.code);
      if (e.code == 'user-not-found') toast('No user found for that email.');
      if (e.code == 'invalid-email') toast('email form isn\'t right');
      if (e.code == 'wrong-password') toast('Wrong password');
      if (e.code == 'too-many-requests') {
        toast('you have try too many times\nplease wait 30 secs');
      }
      if (e.code == 'unknown') toast('check your internet connection');
    }
    return false;
  }

  //* Google 登录功能
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Attempt to sign in the user in with Google
      // Trigger the authentication flow, 调用Google认证
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request, 等待用户完整Google授权的response
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential, 创建一个证书
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential, 一旦登录成功, 回传用户证书
      return await _auth.signInWithCredential(credential);
      // TODO: 处理1个email 多种登录方式的情况
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // The account already exists with a different credential
        logger.w(e.code);
        debugPrint(e.code);
        String email = e.email;
        AuthCredential pendingCredential = e.credential;

        // Fetch a list of what sign-in methods exist for the conflicting user
        List<String> userSignInMethods =
            await _auth.fetchSignInMethodsForEmail(email);

        // If the user has several sign-in methods,
        // the first method in the list will be the "recommended" method to use.
        if (userSignInMethods.first == 'password') {
          // Prompt the user to enter their password
          await Get.to(LoadingDialog());
          // String password = ;
          LoginController loginController = Get.find<LoginController>();
          // Sign the user in to their account with the password
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: email,
            password: loginController.password,
          );

          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);

          // Success! Go back to your application flow
          // return goToApplication();
        }

        // Handle other OAuth providers...
      }
    }
    return null;
  }

  //* 登出功能
  Future<void> signOut() async {
    try {
      String uid = user.uid;
      await _auth.signOut();
      await GoogleSignIn().signOut();
      logger.w('登出用户ID: ' + uid ?? 'null');
      Get.until((route) => false);
      Get.toNamed(Routes.AUTH);
    } catch (e) {
      logger.w('Sign out 失败');
    }
  }
}
