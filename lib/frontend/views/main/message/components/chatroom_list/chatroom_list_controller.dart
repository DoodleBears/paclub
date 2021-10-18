import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:get/get.dart';

class ChatroomListController extends GetxController {
  // Stream chatRooms;
  final friendsStream = List<FriendModel>.empty().obs;
  List<FriendModel> friendList = <FriendModel>[];

  // TODO: 替换为 Module
  final ChatroomRepository chatroomRepository = Get.find<ChatroomRepository>();
  final UserRepository userRepository = Get.find<UserRepository>();

  final UserController userController = Get.find<UserController>();

  @override
  void onInit() async {
    logger.i('启用 ChatroomListController');
    // chatroomRepository.getChatroomList(Constants.myUid);

    friendsStream.listen((_) => listenFriendStream(_));
    friendsStream.bindStream(
        userRepository.getFriendChatroomListStream(AppConstants.uuid));
    update();

    super.onInit();
  }

  int sortFriendList(FriendModel a, FriendModel b) {
    return b.lastMessageTime.compareTo(a.lastMessageTime);
  }

  void listenFriendStream(List<FriendModel> list) {
    logger.i('ChatroomList 状态变动');
    friendList = List<FriendModel>.from(list);
    friendList.sort(sortFriendList);
    int sum = 0;
    for (FriendModel friend in friendList) {
      sum += friend.messageNotRead;
    }
    if (userController.messageNotReadAll != sum) {
      logger.i('未读消息数量改变');
      userController.setAppBadge(count: sum);
    }
    update();
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomListController');
    super.onClose();
  }
}
