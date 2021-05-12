import 'package:get/get.dart';
import 'package:paclub/modules/register/account/register_account_controller.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterAccountBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— RegisterAccountBinding');
    Get.lazyPut<RegisterAccountController>(() => RegisterAccountController());
  }
}
