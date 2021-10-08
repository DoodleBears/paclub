import 'package:get/get.dart';
import 'package:paclub/backend/api/auth_api.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/frontend/views/auth/login/login_controller.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 login 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class LoginBinding implements Bindings {
  @override
  void dependencies() {
    logger.wtf('[自动绑定]依赖注入 —— LoginBinding');

    /// Controller 用到的 Module 和 API
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<AuthModule>(() => AuthModule());

    /// View 用到的 Controller
    Get.lazyPut<AuthEmailController>(() => AuthEmailController());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
