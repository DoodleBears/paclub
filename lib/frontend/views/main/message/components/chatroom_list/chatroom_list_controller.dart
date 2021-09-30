import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:get/get.dart';

class ChatroomListController extends GetxController {
  // Stream chatRooms;
  final friendsStream = List<FriendModel>.empty().obs;

  final ChatroomRepository chatroomRepository = Get.find<ChatroomRepository>();

  @override
  void onInit() async {
    logger.i('启用 ChatroomListController');
    // chatroomRepository.getChatroomList(Constants.myUid);

    friendsStream
        .bindStream(chatroomRepository.getChatroomList(AppConstants.uuid));

    super.onInit();
  }

  @override
  void onClose() {
    friendsStream.close();
    logger.w('关闭 ChatroomListController');
    super.onClose();
  }
}
