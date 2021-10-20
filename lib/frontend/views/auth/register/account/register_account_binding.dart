import 'package:get/get.dart';
import 'package:paclub/backend/api/auth_api.dart';
import 'package:paclub/backend/api/user_api.dart';
import 'package:paclub/backend/repository/remote/firebase_auth_repository.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/frontend/views/auth/register/account/register_account_controller.dart';
import 'package:paclub/utils/logger.dart';

class RegisterAccountBinding implements Bindings {
  @override
  void dependencies() {
    logger.wtf('[自动绑定]依赖注入 —— RegisterAccountBinding');

    /// Controller 用到的 Module 和 API
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<UserApi>(() => UserApi());
    Get.lazyPut<UserModule>(() => UserModule());

    Get.lazyPut<FirebaseAuthRepository>(() => FirebaseAuthRepository());
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<AuthModule>(() => AuthModule());

    /// View 用到的 Controller
    Get.put<AuthEmailController>(AuthEmailController());
    Get.put<RegisterAccountController>(RegisterAccountController());
  }
}
