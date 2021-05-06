import 'package:get/get.dart';
import 'package:paclub/modules/login/login_controller.dart';
import 'package:paclub/repositories/login_repository.dart';
import 'package:paclub/widgets/logger.dart';

// 在进入 login 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class LoginBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('初始化依赖 —— LoginBinding');
    print('初始化依赖 —— LoginBinding');

    Get.lazyPut(() => LoginRepository());
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
