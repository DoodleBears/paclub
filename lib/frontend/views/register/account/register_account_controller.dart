import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/frontend/utils/timer.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/frontend/views/register/form/register_form_controller.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/widgets/notifications/notifications.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/utils/app_response.dart';

class RegisterAccountController extends GetxController {
  // 调用 AuthModule 认证模块
  final AuthModule authModule = Get.put(AuthModule());
  // 调用 AuthEmailController Email认证控制器
  final AuthEmailController authEmailController = Get.find();
  // 从 form controller 获取用户填写的用户名
  final RegisterFormController registerFormController = Get.find();
  // 检查网络状态

  final AppTimer countdownTimer = AppTimer();

  // Loading Button 状态
  bool isLoading = false;
  // 判断密码相关
  String _username = '';
  String _password = '';
  String _rePassword = '';
  bool isEmailOK = true;
  bool isPasswordOK = true;
  bool isRePasswordOK = true;
  bool isRegisterd = false;
  RegExp regExp = RegExp(
      r'^(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.{8,})|(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.[!@#\$%\^&])(?=.{8,})$');
  bool isResendButtonShow = false;
  // 重送 email 倒计时
  int countdown = 0;

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
    isEmailOK = true;
    update();
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

  Future<void> loginAfterSignUp() async {
    if (authEmailController.isEmailVerified()) {
      Get.until((route) => false);
      Get.toNamed(Routes.HOME);
    } else {
      await Future.delayed(const Duration(seconds: 1));
      isResendButtonShow = true;
      update();
      toastCenter(
        'Verify your account\nbefore login',
      );
    }
  }

  Future<void> registerWithEmail(BuildContext context) async {
    // loading 中防止重复请求
    if (isLoading) {
      return;
    }
    // 检查非空, 密码强度, 两次输入密码一致
    if (checkRegisterInfo() == false) return;
    isLoading = true;
    update();
    logger.d('提交注册信息，开始进行账号注册');

    final AppResponse appResponse = await authModule.registerWithEmail(
        _username, _password, registerFormController.name);

    if (appResponse.data != null) {
      isRegisterd = true;
      update();
      snackbar(
          title: 'Verify Your Account',
          msg: 'verification email was sent to:\n' + (authModule.user!.email!),
          icon: Icon(Icons.email, color: accentColor, size: Get.width * 0.08));
    } else {
      toastBottom(appResponse.message);
    }
    isLoading = false;
    update();
  }

  bool checkRegisterInfo() {
    bool check = true;
    if (_username.isEmpty) {
      check = false;
      toastBottom('Email cannot be null');
      isEmailOK = false;
    } else if (_password.isEmpty) {
      check = false;
      toastBottom('Password cannot be null');
      isPasswordOK = false;
    } else if (_rePassword.isEmpty) {
      check = false;
      toastBottom('re-password cannot be null');
      isRePasswordOK = false;
    } else if (_password != _rePassword) {
      isRePasswordOK = false;
      check = false;
      toastBottom('re-password is different to password');
    } else if (regExp.hasMatch(_password) == false) {
      isPasswordOK = false;
      check = false;
      toastBottom(
          'password should include at least 8 characters, 1 uppercase, 1 number allow special characters');
    }
    update();

    return check;
  }
}
