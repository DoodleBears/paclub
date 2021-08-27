import 'package:get/get.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/frontend/views/register/account/register_account_controller.dart';
import 'package:paclub/utils/logger.dart';

class RegisterAccountBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— RegisterAccountBinding');

    // View 页面用到哪些 controller 就 put 哪些
    Get.lazyPut(() => AuthEmailController());
    Get.lazyPut<RegisterAccountController>(() => RegisterAccountController());
  }
}
