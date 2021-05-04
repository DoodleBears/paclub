import 'package:get/get.dart';
import 'package:paclub/modules/register/register_controller.dart';
import 'package:paclub/repositories/register_repository.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    print('RegisterBinding');
    Get.lazyPut(() => RegisterRepository());
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
  }
}
