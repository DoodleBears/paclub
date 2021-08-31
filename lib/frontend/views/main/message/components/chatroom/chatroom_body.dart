import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroller.dart';
import 'package:paclub/helper/constants.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'components/chatroom_message_tile.dart';

class ChatroomBody extends GetView<ChatroomController> {
  final ChatroomScroller chatroomScroller = Get.find<ChatroomScroller>();
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 ChatRoomBody');

    return Column(
      children: [
        // 消息列
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                child: GetBuilder<ChatroomController>(builder: (_) {
                  logger.i('重建 ListView');

                  /// 使用ListView会重新渲染整个 List，80条信息就是渲染80个
                  /// 所以必须用ListView.builder
                  /// 使用 GetBuilder 可以控制渲染更新效果
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: chatroomScroller.scrollController,
                      itemCount: controller.messageStream.length,
                      itemExtent: 68.0,
                      reverse: true,
                      itemBuilder: (context, index) {
                        logger.w('新建 Row: ' + index.toString());
                        return ChatroomMessageTile(
                          message: controller.messageStream[index].message,
                          sendByMe: Constants.myName ==
                              controller.messageStream[index].sendBy,
                        );
                      });
                }),
              ),
              // 消息提示
              GetBuilder<ChatroomScroller>(
                builder: (chatroomScroller) {
                  return AnimatedPositioned(
                    curve: Curves.easeInOutCubic,
                    duration: const Duration(milliseconds: 350),
                    bottom: chatroomScroller.messagesNotRead != 0 &&
                            chatroomScroller.isReadHistory
                        ? 10.0
                        : -40.0,
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                        primary: primaryLightColor,
                        shape: StadiumBorder(),
                        shadowColor: Colors.white,
                      ),
                      onPressed: () => chatroomScroller.jumpToBottom(),
                      child: Text(
                        chatroomScroller.messagesNotRead.toString() + ' Unread',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // 发送框 和 发送按钮 和 消息提示
        Container(
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
            color: Colors.white,
            child: Container(
              height: 100.0,
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: Colors.grey[300],
                      ),
                      child: TextField(
                        maxLines: 1,
                        controller: controller.messageController,
                        style: TextStyle(
                          color: Colors.white,
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
                    onPressed: () async => await controller.addMessage(),
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
