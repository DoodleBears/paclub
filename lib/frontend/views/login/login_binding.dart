import 'package:get/get.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/frontend/views/login/login_controller.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 login 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class LoginBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— LoginBinding');

    // View 页面用到哪些 controller 就 put 哪些
    Get.lazyPut(() => AuthEmailController());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
