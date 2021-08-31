import 'package:get/get.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/frontend/modules/auth_module.dart';

import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/utils/logger.dart';

class SplashController extends GetxController {
  AuthModule authModule = Get.find<AuthModule>();

  // 即，调用阶段，往往是进入某个页面，展示某个元素时，当我们用 GetBuilder<SplashController>
  // 的时候，便会唤起 onReady()
  @override
  void onInit() {
    logger.i('启用 SplashController');
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    logger.d('显示首屏，准备进行登陆检测，启用 AuthModule');

    await Future.delayed(Duration(milliseconds: 1500));

    if (authModule.isLogin() &&
        (useFirestoreEmulator || authModule.isEmailVerified())) {
      // 如果已登录就去task页面
      logger.d('前往主页');
      Get.until((route) => false);
      Get.toNamed(Routes.TABS);
    } else {
      // 如果未登录则前往认证页
      logger.d('前往认证页');
      Get.until((route) => false);
      Get.toNamed(Routes.AUTH);
    }
  }

  @override
  void onClose() {
    logger.w('关闭 SplashController');
    super.onClose();
  }
}
