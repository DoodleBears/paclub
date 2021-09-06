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

class ChatroomBody extends StatefulWidget {
  @override
  _ChatroomBodyState createState() => _ChatroomBodyState();
}

class _ChatroomBodyState extends State<ChatroomBody>
    with WidgetsBindingObserver {
  final ChatroomController chatroomController = Get.find<ChatroomController>();
  final ChatroomScrollController chatroomScrollController =
      Get.find<ChatroomScrollController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  /// [用来检测键盘的出现和消失] This routine is invoked when the window metrics have changed.
  double keyboardHeight = 0.0;
  bool iosKeyboardCheck = false;
  @override
  void didChangeMetrics() {
    if (keyboardHeight == 0.0) {
      // 当键盘出现后，set一次高度之后，就不用再改变了
      keyboardHeight =
          WidgetsBinding.instance!.window.viewInsets.bottom / Get.pixelRatio;
      logger.wtf('键盘高度: $keyboardHeight');
    }
    bool isKeyboardOpen = WidgetsBinding.instance!.window.viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      logger.i('键盘出现');
      // 如果键盘出现，则滚动列表向上，如果是新的聊天室没有消息，则不滚动
      if (chatroomScrollController.scrollController.position.maxScrollExtent >
          100.0) {
        chatroomScrollController.scrollController.jumpTo(
            chatroomScrollController.scrollController.offset + keyboardHeight);
      }
    } else {
      chatroomScrollController.focusNode.unfocus();
      logger.i('键盘消失');
      // 如果键盘消失，则滚动列表向下（如果不在读历史记录，可以直接让键盘消失）
      if (chatroomScrollController.isReadHistory == true && iosKeyboardCheck) {
        chatroomScrollController.scrollController.jumpTo(
            chatroomScrollController.scrollController.offset - keyboardHeight);
        iosKeyboardCheck = false;
      } else if (iosKeyboardCheck == false) {
        iosKeyboardCheck = true;
      }
    }
    chatroomScrollController.bottom =
        chatroomScrollController.scrollController.position.maxScrollExtent;
    if (keyboardHeight == 0.0 && chatroomScrollController.focusNode.hasFocus) {
      chatroomScrollController.focusNode.unfocus();
    }
  }

  // 每次 重建LsitView（一般是有新消息进入，则会重新计算高度）
  afterBuild() {
    if (chatroomScrollController.scrollController.hasClients) {
      /// 最新的 bottom 位置（一般是上次读到的消息的位置，准确来说是上次加载过的最大 ListView 高度）
      /// 注意！ListView.builder 只会加载画面范围附近的Tile，如果不再附近listView不会build，

      /// 在读最新消息(即在聊天室底部)，直接加载最新消息，划入动画
      if (chatroomScrollController.isReadHistory == false) {
        chatroomScrollController.bottom =
            chatroomScrollController.scrollController.position.maxScrollExtent;
        chatroomScrollController.jumpToBottom();
      }

      /// 更新ListView高度
      // if (chatroomScrollController.bottom !=
      //     chatroomScrollController.lastListHeight) {
      //   logger.i(
      //       '更新List高度\n上次的List高度: ${chatroomScrollController.lastListHeight}\n新的List高度: ${chatroomScrollController.bottom}');
      //   chatroomScrollController.lastListHeight =
      //       chatroomScrollController.bottom;
      // }
    } else {
      logger.e('无法找到controller');
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('渲染 ChatRoomBody');
    keyboardHeight = 0.0;
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              GetBuilder<ChatroomController>(builder: (_) {
                logger3.i('重建 ListView,length: ' +
                    chatroomController.messageStream.length.toString());

                /// 使用ListView会重新渲染整个 List，80条信息就是渲染80个
                /// 所以必须用ListView.builder
                /// 使用 GetBuilder 可以控制渲染更新效果
                List<ChatMessageModel> list =
                    chatroomController.messageStream.toList();
                // 有新消息的时候，调用
                WidgetsBinding.instance!
                    .addPostFrameCallback((_) => afterBuild());

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  controller: chatroomScrollController.scrollController,
                  // initialItemCount: controller.messageStream.length,
                  itemCount: chatroomController.messageStream.length,
                  // shrinkWrap: true,
                  padding: EdgeInsets.zero,
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
                  return chatroomScrollController.messagesNotRead != 0 &&
                          chatroomScrollController.isReadHistory
                      ? Positioned(
                          bottom: 6.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 16.0),
                              shape: StadiumBorder(),
                            ),
                            onPressed: () {
                              // 测算按下的时候的 bottom
                              chatroomScrollController.bottom =
                                  chatroomScrollController.scrollController
                                      .position.maxScrollExtent;
                              chatroomScrollController.jumpToBottom();
                            },
                            child: Text(
                              chatroomScrollController.messagesNotRead
                                      .toString() +
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
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2.0,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 5.0),
                )
              ]),
              child: Container(
                color: AppColors.messageBoxContainerBackground,
                padding:
                    const EdgeInsets.only(left: 16.0, top: 18.0, bottom: 28.0),
                alignment: Alignment.topCenter,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: AppColors.messageBoxBackground,
                          ),
                          child: TextField(
                            focusNode: chatroomScrollController.focusNode,
                            controller: chatroomController.messageController,
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
                          await chatroomController.addMessage();
                        },
                        child: Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                height: 1.5,
                color: AppColors.messageBoxBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
