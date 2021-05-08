import 'package:get/get.dart';
import 'package:paclub/data/providers/login_provider.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/logger.dart';

class SplashController extends GetxController {
  // 即，调用阶段，往往是进入某个页面，展示某个元素时，当我们用 GetBuilder<SplashController>
  // 的时候，便会唤起 onReady()
  @override
  void onReady() async {
    super.onReady();

    await Future.delayed(Duration(seconds: 2));
    LoginProvider loginProvider = Get.find<LoginProvider>();
    logger.i('登录状态: ' + loginProvider.isLogin().toString());
    // 如果未登录就登录
    // 如果已登录就去task页面
    if (loginProvider.isLogin()) {
      logger.i('前往主页');
      Get.offNamed(Routes.HOME);
    } else {
      logger.i('前往登录页');
      Get.offNamed(Routes.AUTH);
    }
  }
}
