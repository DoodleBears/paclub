import 'package:get/get.dart';
import 'package:paclub/backend/repository/local/user_preferences.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_controller.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class TabsBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    logger.i('[自动绑定]依赖注入 —— TabsBinding');

    /// TabsController 用来管理 tab
    Get.put(TabsController());

    // 注入UserPreferences
    await UserPreferences.init();
  }
}
