import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_body.dart';
import 'package:flutter/material.dart';

class ChatroomPage extends GetView<ChatroomController> {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 ChatroomPage');
    return GetBuilder<UserController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.chatroomAppBarTitleColor,
              overflow: TextOverflow.clip,
            ),
            title: Text(controller.chatUserName),
            elevation: 0,
          ),
          body: ChatroomBody(),
        );
      },
    );
  }
}
