import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_body.dart';
import 'package:flutter/material.dart';

class ChatroomPage extends GetView<ChatroomController> {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 ChatroomPage');
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.userName),
        elevation: 0,
      ),
      body: ChatroomBody(),
    );
  }
}