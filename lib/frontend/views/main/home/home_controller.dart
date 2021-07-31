import 'package:get/get.dart';
import 'package:paclub/backend/api/auth_api.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/utils/logger.dart';

class HomeController extends GetxController {
  final AuthApi authApi = Get.put(AuthApi());
  final AuthModule authModule = Get.put(AuthModule());
  String testString = '这是从controller获得的string';

  Future<void> signOut() async {
    await authModule.signOut();
  }

  @override
  void onInit() {
    logger.i('启用 HomeController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 HomeController');
    super.onClose();
  }
}
