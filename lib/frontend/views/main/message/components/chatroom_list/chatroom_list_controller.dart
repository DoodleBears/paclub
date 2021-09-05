import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:get/get.dart';

class ChatroomListController extends GetxController {
  // Stream chatRooms;
  final chatroomStream = List<ChatroomModel>.empty().obs;

  final ChatroomRepository chatroomRepository = Get.find<ChatroomRepository>();

  @override
  void onInit() async {
    logger.i('启用 ChatroomListController');
    // chatroomRepository.getChatroomList(Constants.myUid);

    chatroomStream
        .bindStream(chatroomRepository.getChatroomList(AppConstants.uuid));

    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomListController');
    super.onClose();
  }
}
