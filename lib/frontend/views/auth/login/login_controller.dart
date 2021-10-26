import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/utils/timer.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/utils/app_response.dart';

// LoginController交互对象: View(Login_page.dart), Repository(login_repository.dart)

// feat_1: 获取用户输入的账户密码, 提供 login 按钮以登录
// feat_2: Toast信息提示，当用户的操作出现失败时，跳出提示
// feat_3: 显示/隐藏 密码(visibility)
class LoginController extends GetxController {
  final AuthModule authModule = Get.find<AuthModule>();
  final AuthEmailController authEmailController =
      Get.find<AuthEmailController>();
  final AppTimer countdownTimer = AppTimer();

  // 等待登录后的回传
  bool isLoading = false;
  // 默认隐藏密码
  bool hidePassword = true;
  String username = '';
  String password = '';
  String? errorText;
  bool isNeedToResend = false;
  bool isResendButtonShow = false;
  bool isPasswordOK = true;
  bool isEmailOK = true;
  bool isStyleOK = true;
  int countdown = 0;
  late Timer timer;

  void onUsernameChanged(String username) {
    this.username = username.trim();
    if (isEmailOK == false) {
      isEmailOK = true;
      update();
    }
  }

  void onPasswordChanged(String password) {
    this.password = password.trim();
    if (isPasswordOK == false) {
      isPasswordOK = true;
      update();
    }
  }

  void changeSecure() {
    hidePassword = !hidePassword;
    update();
    debugPrint('密码显隐状态: ' + (hidePassword ? '隐藏' : '显示, 密码为:' + password));
  }

  void signInWithGoogle() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    update();

    AppResponse appResponse = await authModule.signInWithGoogle();

    if (appResponse.data != null) {
      Get.until((route) => false);
      Get.toNamed(Routes.TABS);
    }

    isLoading = false;
    update();
  }

  void login() {
    if (authEmailController.isEmailVerified()) {
      Get.until((route) => false);
      Get.toNamed(Routes.TABS);
    }
  }

  void signInWithEmail(BuildContext context) async {
    // loading 中防止重复请求
    if (isLoading) {
      return;
    }
    // 非空检查等, 初步检查
    if (checkSignInInfo() == false) {
      return;
    }
    isLoading = true;
    update();

    logger.d('提交登录信息，开始进行登录验证');

    final AppResponse appResponse =
        await authModule.signInWithEmailAndPassword(username, password);
    if (appResponse.data != null) {
      if (authEmailController.isEmailVerified()) {
        Get.until((route) => false);
        Get.toNamed(Routes.TABS);
      } else {
        isNeedToResend = true;
        update();

        await Future.delayed(const Duration(seconds: 1));
        isResendButtonShow = true;
        update();
      }
    } else {
      if (appResponse.message == 'invalid-email') {
        isEmailOK = false;
      } else if (appResponse.message == 'user-not-found') {
        isEmailOK = false;
      } else if (appResponse.message == 'wrong-password') {
        isPasswordOK = false;
      }
      errorText = appResponse.message;
    }
    isLoading = false;
    update();
  }

  bool checkSignInInfo() {
    isStyleOK = false;
    if (username.isEmpty) {
      errorText = 'Email cannot be empty';
      isEmailOK = false;
      update();
    } else if (password.isEmpty) {
      errorText = 'Password cannot be empty';
      isPasswordOK = false;
      update();
    } else {
      isStyleOK = true;
    }
    return isStyleOK;
  }

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
}
