import 'package:paclub/services/auth_service.dart';

class LoginProvider {
  // 在涉及需要用户登录后才能操作的功能上，都会事先check一遍登录状态，就会调用这个function
  bool isLogin() {
    // 获得login状态的Model，来判断 —— 如果是null则未登录
    // TODO: Auth
    return false;
  }
}
