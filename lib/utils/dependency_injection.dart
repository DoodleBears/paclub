import 'package:get/get.dart';
import 'package:paclub/data/providers/login_provider.dart';
import 'package:paclub/services/app_preference_service.dart';
import 'package:paclub/widgets/logger.dart';

class DenpendencyInjection {
  static Future<void> init() async {
    logger.i('依赖注入, 如 Controller, Service(比如用于检测登录, 自动登录的)');
    //** AppPrefsController 用于管理全局设置(Global Setting)*/
    /// 如: `自动登录`, `黑夜模式`等
    await Get.putAsync(() => AppPrefsController().init());

    // 开始触发自动登录
    // await Get.putAsync(() => AuthService().init());

    Get.put(LoginProvider());
  }
}
