import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_body.dart';
import 'package:flutter/material.dart';

class ChatroomPage extends GetView<ChatroomController> {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 ChatroomPage');
    return GetBuilder<AppController>(
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
            actions: [
              kIsWeb
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          )),
                      label: Text('Load More'),
                      icon: Icon(Icons.update),
                      onPressed: () {
                        controller.webLoading();
                      },
                    )
                  : SizedBox.shrink(),
            ],
          ),
          body: ChatroomBody(),
        );
      },
    );
  }
}
