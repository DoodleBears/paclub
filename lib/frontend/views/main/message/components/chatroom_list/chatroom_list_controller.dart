import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:get/get.dart';

class ChatroomListController extends GetxController {
  // Stream chatRooms;
  final friendsStream = List<FriendModel>.empty().obs;
  List<FriendModel> friendList = <FriendModel>[];

  // final ChatroomModule _chatroomModule = Get.find<ChatroomModule>();
  final UserModule _userModule = Get.find<UserModule>();

  final AppController userController = Get.find<AppController>();

  @override
  void onInit() async {
    logger.i('启用 ChatroomListController');
    // chatroomRepository.getChatroomList(Constants.myUid);

    friendsStream.listen((_) => listenFriendStream(_));
    friendsStream.bindStream(_userModule.getFriendChatroomListStream(AppConstants.uuid));
    update();

    super.onInit();
  }

  // NOTE: 当图片加载失败的时候，考虑到可能是用户更新了图像
  Future<void> updateFriendProfile({
    required FriendModel friendModel,
  }) async {
    logger.d('updateFriendProfile');
    AppResponse appResponseUserProfile =
        await _userModule.getUserProfile(uid: friendModel.friendUid);

    if (appResponseUserProfile.data != null) {
      UserModel updateFriendModel = appResponseUserProfile.data;
      Map<String, dynamic> updateMap = {};
      if (friendModel.avatarURL != updateFriendModel.avatarURL) {
        friendModel.avatarURL = updateFriendModel.avatarURL;
        updateMap['avatarURL'] = updateFriendModel.avatarURL;
      }
      if (friendModel.friendName != updateFriendModel.displayName) {
        friendModel.friendName = updateFriendModel.displayName;
        updateMap['displayName'] = updateFriendModel.displayName;
      }
      if (updateMap.isNotEmpty) {
        AppResponse appResponseUpdateFriendProfile = await _userModule.updateFriendProfile(
            friendUid: friendModel.friendUid, updateMap: updateMap);
        if (appResponseUpdateFriendProfile.data == null) {
          logger.d('FriendProfile 更新失败');
        }
      } else {
        logger.d('FriendProfile 无需更新');
      }
    }
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
