import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/firebase_auth_repository.dart';
import 'package:paclub/frontend/utils/providers/internet_provider.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/backend/repository/local/user_preferences.dart';

class AppBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    logger.i('[自动绑定]依赖注入 —— AppBinding(全局使用注入)');
    // 检查网络用的 Provider
    Get.lazyPut(() => InternetProvider());
    // 授权认证服务的 Service
    Get.lazyPut(() => FirebaseAuthRepository());

    //** AppPrefsController 用于管理全局设置(Global Setting)*/
    /// 如: `自动登录`, `黑夜模式`等
    // TODO: 改为 绑定在 UserPage 上
    await Get.putAsync(() => UserPreferences.init());
  }
}
