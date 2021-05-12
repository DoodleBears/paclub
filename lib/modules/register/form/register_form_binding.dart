import 'package:get/get.dart';
import 'package:paclub/modules/register/form/register_form_controller.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterFormBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— RegisterFormBinding');
    Get.lazyPut<RegisterFormController>(() => RegisterFormController());
  }
}
