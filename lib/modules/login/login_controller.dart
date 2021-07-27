import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/services/auth_service.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/snackbar.dart';
import 'package:paclub/widgets/toast.dart';

// LoginController交互对象: View(Login_page.dart), Repository(login_repository.dart)

// feat_1: 获取用户输入的账户密码, 提供 login 按钮以登录
// feat_2: Toast信息提示，当用户的操作出现失败时，跳出提示
// feat_3: 显示/隐藏 密码(visibility)
class LoginController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  // 等待登录后的回传
  bool isLoading = false;
  // 默认隐藏密码
  bool hidePassword = true;
  String username = '';
  String password = '';
  bool isNeedToResend = false;
  bool isResendButtonShow = false;
  bool isPasswordOK = true;
  bool isEmailOK = true;
  bool isStyleOK = true;
  int countdown = 0;
  late Timer timer;

  @override
  void onInit() {
    logger.i('启用 LoginController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 LoginController');
    super.onClose();
  }

  void setTimer({Function? function, int duration = 1, int time = 30}) {
    logger.d('timer was set to: $countdown');
    update();
    timer = Timer.periodic(Duration(seconds: duration), (t) {
      // logger0.d(countdown);
      if (countdown != 0) {
        countdown--;
        if (function != null) function();
        update();
      } else {
        timer.cancel();
        countdown = 0;
        update();
      }
    });
  }

  void onUsernameChanged(String username) {
    this.username = username.trim();
    isEmailOK = true;
    update();
    // debugPrint('当前用户名:' + username);
  }

  void onPasswordChanged(String password) {
    this.password = password.trim();
    isPasswordOK = true;
    update();
    // debugPrint('当前密码:' + password);
  }

  Future<void> resendEmail({int time = 60}) async {
    countdown = time;
    update();
    logger.d('重送email');
    try {
      await authService.user?.sendEmailVerification();
      // await Future.delayed(const Duration(seconds: 2));
      setTimer(time: countdown);
      snackbar(
        title: 'Verify Your Account',
        msg: 'verification email resend to:\n' +
            (authService.user?.email ?? '未获得email'),
        icon: Icon(
          Icons.email,
          color: accentColor,
          size: Get.width * 0.08,
        ),
      );
      // toast('email resend to\n' + authService.user.email);
    } catch (e) {
      countdown = 0;
      update();
      logger.e(e.toString());
    }
  }

  void changeSecure() {
    hidePassword = !hidePassword;
    update();
    debugPrint('密码显隐状态: ' + (hidePassword ? '隐藏' : '显示, 密码为:' + password));
  }

  void signInWithGoogle() async {
    isLoading = true;
    update();
    var userCredential = await authService.signInWithGoogle();
    logger.i('Google Sign in, 用户ID: ' + (userCredential?.user!.uid ?? 'null'));
    if (userCredential != null) {
      Get.until((route) => false);
      Get.toNamed(Routes.HOME);
    }
    isLoading = false;
    update();
  }

  void loginSubmit(BuildContext context) async {
    // 非空检查等, 初步检查
    if (check() == false) return;
    isLoading = true;
    update();
    final String response =
        await authService.signInWithEmail(username, password);
    if (response == 'Login success') {
      logger.d('邮箱认证状态: ' +
          (authService.user?.emailVerified == true ? '已认证' : '未认证'));
      if (authService.user?.emailVerified == false) {
        isNeedToResend = true;
        update();
        snackbar(
          title: 'Verify Your Account',
          msg: 'You cannot login without verification.',
          icon: Icon(
            Icons.email,
            color: accentColor,
            size: Get.width * 0.08,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        isResendButtonShow = true;
        update();
      } else {
        Get.until((route) => false);
        Get.toNamed(Routes.HOME);
      }
    } else {
      toastLoginError(response);
    }
    isLoading = false;
    update();
  }

  // *  [Email 注册错误的提示信息] 用来 toast login 相关的 error
  void toastLoginError(String code) {
    if (code == 'user-not-found') {
      toast('No user found for that email.');
    } else if (code == 'invalid-email') {
      toast('Email form isn\'t right');
      isEmailOK = false;
    } else if (code == 'wrong-password') {
      toast('Wrong password');
      isPasswordOK = false;
    } else if (code == 'too-many-requests') {
      toast('You have try too many times\nplease wait 30 secs');
    } else if (code == 'unknown') {
      toast('Check your internet connection');
    } else {
      toast('Login failed');
    }
  }

  bool check() {
    isStyleOK = false;
    if (username.isEmpty) {
      toast('Email cannot be null');
      isEmailOK = false;
    } else if (password.isEmpty) {
      toast('Password cannot be null');
      isPasswordOK = false;
    } else {
      isStyleOK = true;
    }
    update();
    return isStyleOK;
  }
}
