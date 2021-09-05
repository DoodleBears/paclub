import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroll_controller.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class ChatroomBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— ChatroomBinding');

    // 如果希望是懒加载，则用下面一行（会导致每次打开页面重新刷新内容，因为 Controller 重建了）
    // Get.lazyPut<MessageController>(() => MessageController());

    /// View 用到的 Controller
    Get.put<ChatroomRepository>(ChatroomRepository());

    /// 一定要先注入 ChatroomScroller, 因为 ChatroomController 有用到 ChatroomScroller
    Get.put<ChatroomScrollController>(ChatroomScrollController());
    Get.put<ChatroomController>(ChatroomController());
  }
}
