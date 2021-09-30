import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/card/card_binding.dart';
import 'package:paclub/frontend/views/main/home/home_binding.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_controller.dart';
import 'package:paclub/frontend/views/main/message/message_binding.dart';
import 'package:paclub/frontend/views/main/notification/notification_binding.dart';
import 'package:paclub/frontend/views/main/user/user_binding.dart';
import 'package:paclub/utils/logger.dart';

class TabsController extends GetxController {
  int currentIndex = 0;

  /// 子页面的依赖注入
  void tabsDependencyInjection(int index) {
    if (index == 0) {
      HomeBinding().dependencies();
    } else if (index == 1) {
      CardBinding().dependencies();
    } else if (index == 2) {
      MessageBinding().dependencies();
    } else if (index == 3) {
      NotificationBinding().dependencies();
    } else {
      UserBinding().dependencies();
    }
  }

  void setIndex(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    // logger.i('当前index是：' + currentIndex.toString());
    tabsDependencyInjection(index);
    update();
  }

  @override
  void onInit() {
    currentIndex = 0;

    logger.i('启用 TabsController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 TabsController');
    ChatroomListController chatroomListController =
        Get.find<ChatroomListController>();
    chatroomListController.friendsStream.close();
    super.onClose();
  }
}
