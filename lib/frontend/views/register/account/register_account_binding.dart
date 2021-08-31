import 'package:get/get.dart';
import 'package:paclub/backend/api/auth_api.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/frontend/views/register/account/register_account_controller.dart';
import 'package:paclub/utils/logger.dart';

class RegisterAccountBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— RegisterAccountBinding');

    /// Controller 用到的 Module 和 API
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<AuthModule>(() => AuthModule());

    /// View 用到的 Controller
    Get.lazyPut<AuthEmailController>(() => AuthEmailController());
    Get.lazyPut<RegisterAccountController>(() => RegisterAccountController());
  }
}
