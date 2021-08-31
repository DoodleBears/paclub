import 'package:paclub/helper/constants.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_controller.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/components/chatroom_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChatroomListBody extends GetView<ChatroomListController> {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 charRoomsListBody');
    return Container(
      child: Obx(() {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: controller.chatroomStream.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            ChatroomModel chatroomModel = controller.chatroomStream[index];
            final userUid = chatroomModel.users[0] == Constants.myUid
                ? chatroomModel.users[1]
                : chatroomModel.users[0];
            final userName = chatroomModel.usersName['$userUid'];
            return ChatroomsUserTile(
                chatroomId: chatroomModel.chatroomId, userName: userName);
          },
        );
      }),
    );
  }
}
