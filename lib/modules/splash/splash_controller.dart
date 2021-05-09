import 'package:get/get.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/services/auth_service.dart';

class SplashController extends GetxController {
  // 即，调用阶段，往往是进入某个页面，展示某个元素时，当我们用 GetBuilder<SplashController>
  // 的时候，便会唤起 onReady()
  @override
  void onReady() async {
    super.onReady();
    AuthService authService = Get.find<AuthService>();

    await Future.delayed(Duration(seconds: 2));
    // 如果未登录就登录
    if (authService.isLogin(notify: false)) {
      logger.i('前往主页');
      Get.offNamed(Routes.HOME);
      // 如果已登录就去task页面
    } else {
      logger.i('前往登录页');
      Get.offNamed(Routes.AUTH);
    }
  }
}
