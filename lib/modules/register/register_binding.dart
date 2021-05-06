import 'package:get/get.dart';
import 'package:paclub/modules/register/register_controller.dart';
import 'package:paclub/repositories/register_repository.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('初始化依赖 —— RegisterBinding');
    print('初始化依赖 —— RegisterBinding');
    Get.lazyPut(() => RegisterRepository());
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
  }
}
