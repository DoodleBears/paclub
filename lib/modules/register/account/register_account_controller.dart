import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/services/auth_service.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/snackbar.dart';
import 'package:paclub/widgets/toast.dart';

class RegisterAccountController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  // Loading Button 状态
  bool isLoading = false;
  // 判断密码相关
  String _username = '';
  String _password = '';
  String _rePassword = '';
  bool isPasswordOK = true;
  bool isRePasswordOK = true;
  bool isRegisterd = false;
  RegExp regExp = RegExp(
      r'^(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.{8,})|(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.[!@#\$%\^&])(?=.{8,})$');
  // 判断是否认证邮箱
  bool isEmailVerifyed = false;
  bool isNeedToResend = false;
  bool isResendButtonShow = false;
  // 重送 email 倒计时
  int countdown = 0;
  late Timer timer;
  // 判断是否是在填写 Profile 信息
  bool isProfile = true;

  @override
  void onInit() {
    logger.i('启用 RegisterAccountController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 RegisterAccountController');
    super.onClose();
  }

  void onUsernameChanged(String username) {
    _username = username.trim();
  }

  void onPasswordChanged(String password) {
    _password = password.trim();
    isPasswordOK = true;
    update();
  }

  void onRePasswordChanged(String repassword) {
    _rePassword = repassword.trim();
    isRePasswordOK = true;
    update();
  }

  void setTimer({Function? function, int duration = 1, int time = 30}) {
    countdown = time;
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

  Future<void> resendEmail({int time = 30}) async {
    countdown = time;
    update();
    logger.d('register: 重送email');
    try {
      await authService.user?.sendEmailVerification();
      // await Future.delayed(const Duration(seconds: 2));
      // 触发一个 countdown 秒的倒计时，并不断调用 authService.reload() 以便用户完成验证时候接收到用户的登陆状态
      setTimer(
        function: () => authService.reload(),
        time: countdown,
      );
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
    } catch (e) {
      countdown = 0;
      update();
      logger.e(e.toString());
    }
  }

  Future<void> submit(BuildContext context) async {
    // 检查非空, 密码强度, 两次输入密码一致
    if (check() == false) return;
    isLoading = true;
    update();
    if (await authService.register(_username, _password)) {
      isRegisterd = true;
      if (authService.user?.emailVerified == false) {
        isEmailVerifyed = false;
        snackbar(
          title: 'Verify Your Account',
          msg: 'verification email already sent to:\n' +
              (authService.user!.email!),
          icon: Icon(
            Icons.email,
            color: accentColor,
            size: Get.width * 0.08,
          ),
        );
        // toast('verification email already sent to:\n' + authService.user.email,
        //     gravity: ToastGravity.CENTER);
        authService.user!.sendEmailVerification();
        // 启用Timer每1s刷新一次用户状态, 持续2min(120s)
        setTimer(
          function: () {
            authService.reload();
            // logger.d('刷新user状态');
          },
          time: 60,
        );
        update();
        logger.d('mail verify:' + isEmailVerifyed.toString());
        // Get.toNamed(Routes.LOGIN);

      } else {
        Get.until((route) => false);
        Get.toNamed(Routes.HOME);
      }
    }
    isLoading = false;
    update();
  }

  bool check() {
    bool check = true;
    if (_username.isEmpty) {
      check = false;
      toast('Email cannot be null');
    } else if (_password.isEmpty) {
      check = false;
      toast('Password cannot be null');
      isPasswordOK = false;
    } else if (_rePassword.isEmpty) {
      check = false;
      toast('re-password cannot be null');
      isRePasswordOK = false;
    } else if (_password != _rePassword) {
      isRePasswordOK = false;
      check = false;
      toast('re-password is different to password');
    } else if (regExp.hasMatch(_password) == false) {
      isPasswordOK = false;
      check = false;
      toast(
          'password should include at least 8 characters, 1 uppercase, 1 number allow special characters');
    }
    update();

    return check;
  }

  void checkEmailVerified() {
    authService.reload();
    if (authService.user?.emailVerified == false) {
      isEmailVerifyed = true;
    } else {
      isEmailVerifyed = false;
    }
    update();
  }

  void checkResendEmail() async {
    authService.reload();
    logger.d('email 是否认证: ' + authService.user!.emailVerified.toString());
    if (authService.user!.emailVerified) {
      isResendButtonShow = false;
      isEmailVerifyed = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
      isNeedToResend = false;
      update();
    } else {
      isNeedToResend = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
      isResendButtonShow = true;
      update();
    }
  }
}
