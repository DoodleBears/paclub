import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_controller.dart';
import 'package:paclub/frontend/views/main/message/message_controller.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class MessageBinding implements Bindings {
  @override
  void dependencies() {
    logger.wtf('[自动绑定]依赖注入 —— MessageBinding');

    // 如果希望是懒加载，则用下面一行（会导致每次打开页面重新刷新内容，因为 Controller 重建了）
    // Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<ChatroomRepository>(() => ChatroomRepository());
    // Get.lazyPut<UserRepository>(() => UserRepository());
    // Get.lazyPut<UserSearchController>(() => UserSearchController());
    Get.lazyPut<ChatroomListController>(() => ChatroomListController());

    /// View 用到的 Controller
    Get.put<MessageController>(MessageController());
  }
}
