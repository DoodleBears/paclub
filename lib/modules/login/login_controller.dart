import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:paclub/repositories/login_repository.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/toast.dart';

// LoginController交互对象: View(Login_page.dart), Repository(login_repository.dart)

// feat_1: 获取用户输入的账户密码, 提供 login 按钮以登录
// feat_2: Toast信息提示，当用户的操作出现失败时，跳出提示
// feat_3: 显示/隐藏 密码(visibility)
class LoginController extends GetxController {
  final LoginRepository repository = Get.find<LoginRepository>();

  // 等待登录后的回传
  bool isLoading = false;
  // 默认隐藏密码
  bool hidePassword = true;
  String _username;
  String _password;

  void onUsernameChanged(String username) {
    _username = username.trim();
    print('当前用户名:' + _username);
  }

  void onPasswordChanged(String password) {
    _password = password.trim();
    print('当前密码:' + _password);
  }

  void changeSecure() {
    hidePassword = hidePassword ? false : true;
    update();
    print('密码显隐状态: ' + (hidePassword ? '隐藏' : '显示' + _password));
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
    isLoading = true;
    update();
    // await Future.delayed(const Duration(seconds: 3));
    String loginInfo = await repository.login(_username, _password);
    isLoading = false;
    update();
    if (loginInfo == 'login successed') {
      //** 希望被pop掉的页面有动画, 则用下面这1个 */
      /// 用 Get.offNamed() 相当于 `pushReplacementNamed`, 会有 pop 的动画, 因为实际操作是先pop了当前页面, 再push
      //** 反之, 不要有动画 */
      /// `1.当只需要pop掉当前1个页面时` Get.offAndToNamed() 相当于 `popAndPushNamed()`, 只会让enter page执行enter动画, 实际操作是先push了新页面，等Push动画结束之后再Pop原本要pop的旧页面
      /// `2.当需要pop掉很n个页面时` 先用 Get.until(), 然后用 Get.toNamed() `下面的例子就是`
      // **Get.until(page, (route) => (route as GetPageRoute).routeName == Routes.HOME) 的话就是 pop 到 Home Page 就停下来(Home不会被Pop)
      // **这里写作 Get.until((route) => false), 就是全部回传false, 全部 pop 掉
      print('登录成功 —— 前往主页');

      Get.until((route) => false);
      Get.toNamed(Routes.HOME);
    } else {
      print('登录失败: ' + loginInfo);

      toast(loginInfo);
    }
  }
}
