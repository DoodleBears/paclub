import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/functions/transitions.dart';
import 'package:paclub/modules/login/login_page.dart';
import 'package:paclub/modules/register/register_page.dart';
import 'package:paclub/pages/Tabs.dart';
import 'package:paclub/repositories/register_repository.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/toast.dart';

class RegisterController extends GetxController {
  final RegisterRepository repository = Get.find<RegisterRepository>();
  // 等待登录后的回传
  bool isLoading = false;
  String _username;
  String _password;
  String _rePassword;
  bool isPasswordOK = true;
  bool isRePasswordOK = true;

  RegExp regExp = RegExp(
      r"^(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.{8,})|(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])(?=.[!@#\$%\^&])(?=.{8,})$");

  void onUsernameChanged(String username) {
    _username = username.trim();
  }

  void onPasswordChanged(String password) {
    _password = password.trim();
    isPasswordOK = true;
    update();
  }

  _checkPasswordWeakness() {
    if (regExp.hasMatch(_password) == false) {
      isPasswordOK = false;
      toast(
          'password should include at least 8 characters, 1 uppercase, 1 number allow special characters');
    }
    update();
  }

  void onRePasswordChanged(String repassword) {
    _rePassword = repassword.trim();
    isRePasswordOK = true;
    update();
  }

  void submit(BuildContext context) async {
    if (_username == null || _username.isEmpty) {
      toast('Email cannot be null');
      return;
    }

    if (_password == null || _password.isEmpty) {
      toast('Password cannot be null');
      return;
    }
    if (_rePassword == null || _rePassword.isEmpty) {
      toast('re-password cannot be null');
      return;
    }
    if (_password != _rePassword) {
      toast('re-password is different to password');
      isRePasswordOK = false;
      update();
      return;
    }
    await _checkPasswordWeakness();
    if (isPasswordOK == false) return;

    isLoading = true;
    update();

    String registerInfo = await repository.register(_username, _password);
    isLoading = false;
    update();
    if (registerInfo == 'register successed') {
      // Get.offAllNamed(Routes.HOME);
      // 使用自定义的动画，exit效果和enter效果与预设不同
      Navigator.pushAndRemoveUntil(
        context,
        BelowDownTopHoldRoute(exitPage: RegisterPage(), enterPage: Tabs()),
        (Route<dynamic> route) => false,
      );
    } else {
      toast(registerInfo);
    }
  }
}
