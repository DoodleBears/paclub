import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/services/auth_service.dart';
import 'package:paclub/widgets/logger.dart';
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
  String _username;
  String _password;
  bool isNeedToResend = false;
  bool isResendButtonShow = false;
  bool isPasswordOK = true;
  int countdown = 0;
  Timer timer;

  String get password => _password;

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

  void setTimer({Function function, int duration = 1, int time = 30}) {
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

  Future<void> resendEmail({int time = 60}) async {
    countdown = time;
    update();
    logger.d('重送email');
    try {
      await authService.user.sendEmailVerification();
      // await Future.delayed(const Duration(seconds: 2));
      setTimer(time: countdown);
      toast('email resend to\n' + authService.user.email);
    } catch (e) {
      countdown = 0;
      update();
      logger.e(e.toString());
    }
  }

  void onUsernameChanged(String username) {
    _username = username.trim();

    // debugPrint('当前用户名:' + _username);
  }

  void onPasswordChanged(String password) {
    _password = password.trim();
    isPasswordOK = true;
    update();
    // debugPrint('当前密码:' + _password);
  }

  void changeSecure() {
    hidePassword = !hidePassword;
    update();
    debugPrint('密码显隐状态: ' +
        (hidePassword ? '隐藏' : '显示, 密码为:' + (_password ?? 'null')));
  }

  void signInWithGoogle() async {
    isLoading = true;
    update();
    var userCredential = await authService.signInWithGoogle();
    logger.i('Google Sign in, 用户ID: ' +
        (userCredential == null ? 'null' : userCredential.user.uid));
    if (userCredential != null) {
      Get.until((route) => false);
      Get.toNamed(Routes.HOME);
    }
    isLoading = false;
    update();
  }

  void submit(BuildContext context) async {
    // 非空检查等, 初步检查
    if (check() == false) return;
    isLoading = true;
    update();
    if (isPasswordOK = await authService.login(_username, _password)) {
      logger.d('邮箱认证状态: ' + authService.user.emailVerified.toString());
      if (authService.user.emailVerified == false) {
        isNeedToResend = true;
        update();
        toast('Check verification mail in\n' + authService.user.email,
            gravity: ToastGravity.CENTER);
        await Future.delayed(const Duration(seconds: 1));
        isResendButtonShow = true;
        update();
      } else {
        Get.until((route) => false);
        Get.toNamed(Routes.HOME);
      }
    }
    isLoading = false;
    update();
  }

  bool check() {
    if (_username == null || _username.isEmpty) {
      toast('Email cannot be null');
      isPasswordOK = false;
    } else if (_password == null || _password.isEmpty) {
      toast('Password cannot be null');
      isPasswordOK = false;
    } else {
      isPasswordOK = true;
    }
    update();
    return isPasswordOK;
  }
}
