import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/card/card_binding.dart';
import 'package:paclub/frontend/views/main/home/home_binding.dart';
import 'package:paclub/frontend/views/main/message/message_binding.dart';
import 'package:paclub/frontend/views/main/notification/notification_binding.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_controller.dart';
import 'package:paclub/frontend/views/main/user/user_binding.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class TabsBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— TabsBinding');

    /// View 用到的 Controller
    Get.put<TabsController>(TabsController());
    // 具体 5个Tab 的依赖
    CardBinding().dependencies();
    HomeBinding().dependencies();
    MessageBinding().dependencies();
    NotificationBinding().dependencies();
    UserBinding().dependencies();
  }
}
