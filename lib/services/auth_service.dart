import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paclub/data/providers/internet_provider.dart';
import 'package:paclub/modules/register/form/register_form_controller.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/toast.dart';

// *  [文件说明]
//    提供用户所有信息的 Service, 之所以是 `extends GetxService`
//    是因为 Authentication 是永恒存在于 User 使用期间的, 即整个 App 存活期间的，直到app完全退出
//    之所以 AuthService 要存活在整个生命周期中
//    是因为我们当用户操作时需要处理到用户的信息（可能是浏览记录或是其他数据），所以要时刻检查用户状态
// *  [使用场景]
//    无论是登录, 还是没有登录, 都需要用到他
//    [没登录时] : 用它登录
//    [登录后用] : 它会存住用户的资料, 以便登出, 点赞, 等各种跟User有关的操作
class AuthService extends GetxService {
  // 获取 firebase 提供的 firebaseAuth object
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // 宣告一个 User(Firebase提供的object) 的 stream 类型 object 来监控用户状态
  // late final Rx<User> _user;
  // 宣告 InternetProvider 来监控用户的网络状态
  final InternetProvider internetProvider = Get.find<InternetProvider>();

  // 获得 user, 使用 firebase 的
  User? get user => _auth.currentUser;

  // *  [初始化 Service] 绑定监听 user 和 connectivity 状态
  @override
  void onInit() {
    super.onInit();
    logger.i('初始化 AuthService');
    // 一旦 _auth 状态改变, _user 就会被重新赋值
    // _user.bindStream(_auth.authStateChanges());
    _auth.authStateChanges().listen((User? user) {
      // 一旦用户丢失在线状态
      if (user == null) {
        logger.d('Firebase 检测到用户状态为: 未登录');
      } else {
        logger.d('用户登录: ' + user.uid);
      }
    });
  }

  // *  [结束 Service] 关闭监听 user 状态
  @override
  void onClose() {
    logger.w('关闭 authService');
    super.onClose();
  }

  // *  [重载用户] 当用户登陆或切换状态时候需要用到
  void reload() {
    user!.reload();
  }

  // *  [检测是否登陆]
  bool isLogin({bool notify = true, bool jump = false}) {
    if (user == null || user!.emailVerified == false) {
      if (notify) {
        // 是否跳出提示, 默认值为true, 传入 false 则不toast
        toast(user == null ? 'Please login first' : 'Please verify your email');
      }
      // 是否要强制用户跳转到登录页面, jump 传入 true 则强制跳转
      if (jump) {
        Get.until((route) => false);
        Get.toNamed(Routes.AUTH);
      }
      return false;
    }
    return true;
  }

  // *  [Email 注册功能]
  Future<String> registerWithEmail(String email, String password) async {
    try {
      // 检查网络链接, 如果未联网(false), 提示user联网并取消register
      if (await internetProvider.isConnected() == false) {
        toast('Check your internet connection');
      }
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      logger.d('账号注册通过: $email');
      RegisterFormController registerFormController =
          Get.find<RegisterFormController>();

      await user!.updateDisplayName(registerFormController.name);
      logger.d('更新账号信息成功, name是: ${registerFormController.name}');

      // 确认联网情况正常, 并完成注册后返回 true
      return 'Register success';
    } on FirebaseAuthException catch (e) {
      logger.d('eamil注册失败, 错误码:' + e.code);
      return e.code;
    } catch (e) {
      logger.e(e);
      return e.toString();
    }
  }

  //*  [Email 登录功能]
  Future<String> signInWithEmail(String email, String password) async {
    try {
      // 检查网络链接, 如果未联网(false), 提示user联网并取消 login
      if (await internetProvider.isConnected() == false) {
        toast('Check your internet connection');
      }
      // 使用 Firebase 提供的[用Email登陆]方法
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // 确认联网情况正常, 并完成登录后返回 true
      return 'Login success';
    } on FirebaseAuthException catch (e) {
      logger.d('eamil登录失败, 错误码:' + e.code);
      return e.code;
    }
  }

  // *  [使用Google账号登录功能]
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 检查网络链接, 如果未联网(false), 提示user联网并取消 login
      if (await internetProvider.isConnected() == false) return null;
      // 调用Google登陆认证, 弹窗并等待用户选择账号
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // 等待用户完整Google授权的response, 如果用户取消, 则 googleUser 为 null
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // 验证认证成功, 用 googleAuth 创建一个证书
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 使用该证书登陆 (可以是 Twitter, Google 等证书)
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // TODO: 解决如果账号已经用 email 注册登陆后, 想用同一个 email 对应的 google account 登陆的情况
      if (e.code == 'account-exists-with-different-credential') {
        logger.w(e.code);
        debugPrint(e.code);
      }
    }
    return null;
  }

  // *  [登出功能]
  Future<void> signOut() async {
    try {
      String uid = user!.uid;
      // 登出以 Email 方式登陆的 User
      await _auth.signOut();
      // 登出以 Google账号 方式登陆的User
      await GoogleSignIn().signOut();
      logger.d('登出用户ID: ' + uid);
      // [清空所有页面] pop all the page in stack
      Get.until((route) => false);
      // 跳转到 authentication 页面
      Get.toNamed(Routes.AUTH);
    } catch (e) {
      logger.w('Sign out 失败');
    }
  }
}
