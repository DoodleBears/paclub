import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paclub/data/providers/internet_provider.dart';
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
  final InternetProvider internetProvider = Get.find<InternetProvider>();

  // 获得 user
  User get user => _auth.currentUser;

  // 初始化 Service, 绑定监听 user 和 connectivity 状态
  @override
  void onInit() {
    super.onInit();
    logger.i('初始化 AuthService');
    // 一旦 _auth 状态改变, _user 就会被重新赋值
    _user.bindStream(_auth.authStateChanges());
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        logger.d('Firebase 检测到用户状态为: 未登录');
      } else {
        logger.d('用户登录: ' + (user == null ? 'null' : user.uid));
      }
    });
  }

  // 结束 Service, 关闭监听
  @override
  void onClose() {
    logger.w('关闭 authService');
    super.onClose();
  }

  //* 判断是否登录
  bool isLogin({bool notify = true, bool jump = false}) {
    if (user == null) {
      if (notify) toast('请先登录'); // 是否跳出提示, 默认值为true, 传入 false 则不toast
      // 是否要强制用户跳转到登录页面, jump 传入 true 则强制跳转
      if (jump) {
        Get.until((route) => false);
        Get.toNamed(Routes.AUTH);
      }
      return false;
    }
    if (user?.emailVerified == false) return false;
    return true;
  }

  //* Email 注册功能
  Future<bool> register(String email, String password) async {
    try {
      // 检查网络链接, 如果未联网(false), 提示user联网并取消register
      if (await internetProvider.isConnected() == false) return false;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // 确认联网情况正常, 并完成注册后返回 true
      return true;
    } on FirebaseAuthException catch (e) {
      logger.d('eamil注册失败, 错误码:' + e.code);
      toastRegisterError(e.code);
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  // 用来 toast register 相关的 error
  void toastRegisterError(String code) {
    if (code == 'weak-password') {
      toast('weak password');
    } else if (code == 'invalid-email') {
      toast('email form isn\'t right');
    } else if (code == 'email-already-in-use') {
      toast('account already exists');
    } else if (code == 'too-many-requests') {
      toast('you have try too many times\nplease wait 30 secs');
    } else if (code == 'unknown') {
      toast('check your internet connection');
    } else {
      toast('register fail');
    }
  }

  //* Email 登录功能
  Future<bool> login(String email, String password) async {
    try {
      // 检查网络链接, 如果未联网(false), 提示user联网并取消 login
      if (await internetProvider.isConnected() == false) return false;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // 确认联网情况正常, 并完成登录后返回 true
      return true;
    } on FirebaseAuthException catch (e) {
      logger.d('eamil登录失败, 错误码:' + e.code);
      toastLoginError(e.code);
    }
    return false;
  }

  // 用来 toast login 相关的 error
  void toastLoginError(String code) {
    if (code == 'user-not-found') {
      toast('No user found for that email.');
    } else if (code == 'invalid-email') {
      toast('email form isn\'t right');
    } else if (code == 'wrong-password') {
      toast('Wrong password');
    } else if (code == 'too-many-requests') {
      toast('you have try too many times\nplease wait 30 secs');
    } else if (code == 'unknown') {
      toast('check your internet connection');
    } else {
      toast('Login failed');
    }
  }

  //* Google 登录功能
  Future<UserCredential> signInWithGoogle() async {
    try {
      // 检查网络链接, 如果未联网(false), 提示user联网并取消 login
      if (await internetProvider.isConnected() == false) return null;
      // 调用Google登陆认证, 弹窗并等待用户选择账号
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

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
      // sign out 每一种登陆方式
      await _auth.signOut();
      await GoogleSignIn().signOut();
      logger.d('登出用户ID: ' + uid ?? 'null');
      Get.until((route) => false);
      Get.toNamed(Routes.AUTH);
    } catch (e) {
      logger.w('Sign out 失败');
    }
  }
}
