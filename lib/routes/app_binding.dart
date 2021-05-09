import 'package:get/get.dart';
import 'package:paclub/services/auth_service.dart';
import 'package:paclub/widgets/logger.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    logger.d('初始化依赖 —— AppBinding');
    Get.put<AuthService>(AuthService());
  }
}
