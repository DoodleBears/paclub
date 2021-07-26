import 'package:get/get.dart';
import 'package:paclub/modules/main/card/card_controller.dart';
import 'package:paclub/modules/main/home/home_controller.dart';
import 'package:paclub/modules/main/message/message_controller.dart';
import 'package:paclub/modules/main/notification/notification_controller.dart';
import 'package:paclub/modules/main/tabs/tabs_controller.dart';
import 'package:paclub/modules/main/user/user_controller.dart';
import 'package:paclub/widgets/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class TabsBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— TabsBinding');
    Get.lazyPut<TabsController>(() => TabsController());

    // lazyPut —— 只有真正调用到需要 NotificationController 的地方才会 onInit()
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CardController>(() => CardController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<UserController>(() => UserController());
  }
}
