import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/services/auth_service.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/toast.dart';

class RegisterController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  // 等待登录后的回传
  bool isLoading = false;
  String _username;
  String _password;
  String _rePassword;
  bool isPasswordOK = true;
  bool isRePasswordOK = true;
  RegExp regExp = RegExp(
      r'^(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.{8,})|(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.[!@#\$%\^&])(?=.{8,})$');

  @override
  void onInit() {
    logger.i('启用 RegisterController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 RegisterController');
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

  void submit(BuildContext context) async {
    // 检查非空, 密码强度, 两次输入密码一致
    if (check() == false) return;
    isLoading = true;
    update();
    if (await authService.register(_username, _password)) {
      Get.until((route) => false);
      Get.toNamed(Routes.HOME);
    }
    isLoading = false;
    update();
  }

  bool check() {
    if (_username == null || _username.isEmpty) {
      toast('Email cannot be null');
      return false;
    }
    if (_password == null || _password.isEmpty) {
      toast('Password cannot be null');
      return false;
    }
    if (_rePassword == null || _rePassword.isEmpty) {
      toast('re-password cannot be null');
      return false;
    }
    if (_password != _rePassword) {
      isRePasswordOK = false;
      toast('re-password is different to password');
      update();
      return false;
    }
    if (regExp.hasMatch(_password) == false) {
      isPasswordOK = false;
      toast(
          'password should include at least 8 characters, 1 uppercase, 1 number allow special characters');
      update();
      return false;
    }
    return true;
  }
}
