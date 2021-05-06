import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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
      //** 希望被pop掉的页面有动画, 则用下面这1个 */
      /// 用 Get.offNamed() 相当于 `pushReplacementNamed`, 会有 pop 的动画, 因为实际操作是先pop了当前页面, 再push
      //** 反之, 不要有动画 */
      /// `1.当只需要pop掉当前1个页面时` Get.offAndToNamed() 相当于 `popAndPushNamed()`, 只会让enter page执行enter动画, 实际操作是先push了新页面，等Push动画结束之后再Pop原本要pop的旧页面
      /// `2.当需要pop掉很n个页面时` 先用 Get.until(), 然后用 Get.toNamed() `下面的例子就是`
      // **Get.until(page, (route) => (route as GetPageRoute).routeName == Routes.HOME) 的话就是 pop 到 Home Page 就停下来(Home不会被Pop)
      // **这里写作 Get.until((route) => false), 就是全部回传false, 全部 pop 掉
      print('注册成功 —— 前往主页');

      Get.until((route) => false);
      Get.toNamed(Routes.HOME);
      // Get.offNamedUntil(Routes.HOME, (Route<dynamic> route) => false);
    } else {
      print('注册失败: ' + registerInfo);

      toast(registerInfo);
    }
  }
}
