import 'package:get/get.dart';
import 'package:paclub/frontend/views/register/form/register_form_controller.dart';
import 'package:paclub/utils/logger.dart';

class RegisterFormBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— RegisterFormBinding');

    Get.lazyPut<RegisterFormController>(() => RegisterFormController());
  }
}
