import 'package:paclub/frontend/widgets/others/app_scroll_behavior.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/helper/chatroom_helper.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_controller.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/components/chatroom_list_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChatroomListBody extends GetView<ChatroomListController> {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 charRoomsListBody');
    return Container(
      child: GetBuilder<ChatroomListController>(builder: (_) {
        return ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: controller.friendList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              FriendModel friendModel = controller.friendList[index];

              final userName = friendModel.friendName;
              return ChatroomsListUserTile(
                avatarURL: friendModel.avatarURL,
                lastMessageTime: friendModel.lastMessageTime,
                lastMessage: friendModel.lastMessage,
                messageNotRead: friendModel.messageNotRead,
                chatroomId:
                    getChatRoomId(AppConstants.uuid, friendModel.friendUid),
                userUid: friendModel.friendUid,
                userName: userName,
              );
            },
          ),
        );
      }),
    );
  }
}
