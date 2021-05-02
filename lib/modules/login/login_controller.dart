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
  }

  void onPasswordChanged(String password) {
    _password = password.trim();
  }

  void changeSecure() {
    hidePassword = hidePassword ? false : true;
    update();
  }

  void submit() async {
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

    String loginInfo = await repository.login(_username, _password);
    isLoading = false;
    update();
    if (loginInfo == 'login successed') {
      Get.offAllNamed(Routes.HOME);
    } else {
      toast(loginInfo);
    }
  }
}
