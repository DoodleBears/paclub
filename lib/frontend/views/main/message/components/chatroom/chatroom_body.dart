import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroll_controller.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'components/chatroom_message_tile.dart';

class ChatroomBody extends GetView<ChatroomController> {
  final ChatroomScrollController chatroomScroller =
      Get.find<ChatroomScrollController>();
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 ChatRoomBody');

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              GetBuilder<ChatroomController>(builder: (_) {
                logger.i('重建 ListView,length: ' +
                    controller.messageStream.length.toString());

                /// 使用ListView会重新渲染整个 List，80条信息就是渲染80个
                /// 所以必须用ListView.builder
                /// 使用 GetBuilder 可以控制渲染更新效果
                List<ChatMessageModel> list =
                    controller.messageStream.reversed.toList();
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: chatroomScroller.scrollController,
                  // initialItemCount: controller.messageStream.length,
                  itemCount: controller.messageStream.length,
                  // shrinkWrap: true,
                  // FIXME 不能给定固定高度，消息高度是变化的
                  reverse: true,

                  itemBuilder: (context, index) {
                    return GetBuilder<ChatroomScrollController>(
                      builder: (_) {
                        return ChatroomMessageTile(
                          senderName: list[index].sendBy,
                          message: list[index].message,
                          sendByMe: AppConstants.userName == list[index].sendBy,
                        );
                      },
                    );
                  },
                );
              }),

              // 消息提示
              GetBuilder<ChatroomScrollController>(
                builder: (_) {
                  return chatroomScroller.messagesNotRead != 0 &&
                          chatroomScroller.isReadHistory
                      ? Positioned(
                          bottom: 6.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 16.0),
                              shape: StadiumBorder(),
                            ),
                            onPressed: () => chatroomScroller.jumpToBottom(),
                            child: Text(
                              chatroomScroller.messagesNotRead.toString() +
                                  ' Unread',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),
              // 顶部黑色线条
              Positioned(
                child: Container(
                  height: 1.0,
                  color: AppColors.messageBoxBackground,
                ),
              ),
            ],
          ),
        ),

        // 发送框 和 发送按钮
        Container(
          height: 100.0,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 4.0,
              blurRadius: 8.0,
              offset: Offset(0.0, 0.0),
            )
          ]),
          alignment: Alignment.bottomRight,
          child: Container(
            color: AppColors.messageBoxContainerBackground,
            child: Container(
              height: 100.0,
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: AppColors.messageBoxBackground,
                      ),
                      child: TextField(
                        controller: controller.messageController,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: "Message ...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 10),
                  // 送出訊息的按鈕，調用上面創的addMessage()函式
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10.0),
                      primary: accentColor,
                      shape: CircleBorder(),
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () async {
                      await controller.addMessage();
                    },
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
