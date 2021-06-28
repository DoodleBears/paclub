import 'package:get/get.dart';
import 'package:paclub/data/providers/internet_provider.dart';
import 'package:paclub/services/app_preference_service.dart';
import 'package:paclub/services/auth_service.dart';
import 'package:paclub/widgets/logger.dart';

class AppBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    logger.i('[自动绑定]依赖注入 —— AppBinding(全局使用注入)');
    // 检查网络用的 Provider
    Get.lazyPut<InternetProvider>(() => InternetProvider());
    // 授权认证服务的 Service
    Get.put<AuthService>(AuthService());
    //** AppPrefsController 用于管理全局设置(Global Setting)*/
    /// 如: `自动登录`, `黑夜模式`等
    await Get.putAsync(() => AppPrefsService().init());
  }
}
