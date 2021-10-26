import 'package:get/get.dart';
import 'package:paclub/frontend/views/auth/register/form/register_form_controller.dart';
import 'package:paclub/utils/logger.dart';

class RegisterFormBinding implements Bindings {
  @override
  void dependencies() {
    logger.wtf('[自动绑定]依赖注入 —— RegisterFormBinding');

    Get.put<RegisterFormController>(RegisterFormController());
  }
}
