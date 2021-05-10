import 'package:get/get.dart';
import 'package:paclub/modules/register/register_controller.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— RegisterBinding');
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
