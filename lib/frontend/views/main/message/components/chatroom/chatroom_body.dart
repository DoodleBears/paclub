import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/auth/login/components/components.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroll_controller.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  double keyboardHeightPixel = 0.0;
  double keyboardHeightOrigin = 0.0;
  bool isKeyboardShow = false; //防止出现didChangeMetrics因为键盘出现/消失多次触发
  @override
  void didChangeMetrics() {
    chatroomScrollController.isMetricsChangeing = true;
    // 如果键盘高度不是0，或键盘高度发生变化，更新键盘高度
    if ((WidgetsBinding.instance!.window.viewInsets.bottom !=
                keyboardHeightOrigin &&
            WidgetsBinding.instance!.window.viewInsets.bottom != 0.0) ||
        keyboardHeightPixel == 0.0) {
      keyboardHeightOrigin = WidgetsBinding.instance!.window.viewInsets.bottom;
      keyboardHeightPixel = keyboardHeightOrigin / Get.pixelRatio;

      logger.wtf('键盘高度: $keyboardHeightPixel');
    }
    // 用 viewInsets.bottom 判断是否打开键盘
    bool isKeyboardOpen =
        WidgetsBinding.instance!.window.viewInsets.bottom > 0.0;
    // 如果当时键盘高度 > 0 ，且键盘并不是已经打开了
    if (isKeyboardOpen && isKeyboardShow == false) {
      isKeyboardShow = true;
      logger.i('键盘出现，键盘高度: $keyboardHeightPixel');
      // logger.d(
      //     'maxExtent: ${chatroomScrollController.scrollController.position.maxScrollExtent}\nGetHeight: ${Get.height}');
      // 如果键盘出现，则滚动列表向上，如果是新的聊天室没有消息，则不滚动
      if (chatroomScrollController.scrollController.position.maxScrollExtent >
          80.0) {
        chatroomScrollController.scrollController.jumpTo(
            chatroomScrollController.scrollController.offset +
                keyboardHeightPixel);
      }
    } else if (isKeyboardOpen == false && isKeyboardShow) {
      // 如果当时键盘 == 0（即键盘关闭），且键盘并不是已经关闭了
      // chatroomScrollController.focusNode.unfocus();
      isKeyboardShow = false;
      logger.i('键盘消失，键盘高度: $keyboardHeightPixel');

      // 如果键盘消失，则滚动列表向下（如果消息数量太少，则不滚动）
      // logger.d(
      //     'maxExtent: ${chatroomScrollController.scrollController.position.maxScrollExtent}\nGetHeight: ${Get.height}');
      if (chatroomScrollController.isReadHistory == true) {
        chatroomScrollController.scrollController.jumpTo(
            chatroomScrollController.scrollController.offset -
                keyboardHeightPixel);
      }
      if (chatroomScrollController.focusNode.hasFocus) {
        chatroomScrollController.focusNode.unfocus();
      }
    }

    chatroomScrollController.isMetricsChangeing = false;
  }

  // 每次 重建LsitView（一般是有新消息进入，则会重新计算高度）
  afterBuild() {
    // logger.d('itemBuild 完成');
    if (chatroomScrollController.scrollController.hasClients) {
      /// 注意！ListView.builder 只会加载画面范围附近的Tile，如果不再附近listView不会build，

      /// 在读最新消息(即在聊天室底部)，直接加载最新消息，划入动画
      if (chatroomScrollController.isReadHistory == false) {
        chatroomScrollController.scrollToBottom();
      }
    } else {
      logger.e('无法找到controller');
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('渲染 ChatRoomBody');
    keyboardHeightPixel = 0.0;
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
                  // shrinkWrap: true,
                  controller: chatroomScrollController.scrollController,
                  // initialItemCount: controller.messageStream.length,
                  itemCount: chatroomController.messageStream.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return AutoScrollTag(
                      controller: chatroomScrollController.scrollController,
                      index: index,
                      key: ValueKey(index),
                      child: GetBuilder<ChatroomScrollController>(
                        builder: (_) {
                          return ChatroomMessageTile(
                            senderName: list[index].sendBy,
                            message: list[index].message,
                            sendByMe:
                                AppConstants.userName == list[index].sendBy,
                          );
                        },
                      ),
                    );
                  },
                );
              }),

              // 消息提示
              GetBuilder<ChatroomScrollController>(
                builder: (_) {
                  return Visibility(
                    visible: chatroomScrollController.messagesNotRead != 0 &&
                        chatroomScrollController.isReadHistory,
                    child: Positioned(
                      bottom: 6.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 16.0),
                          shape: StadiumBorder(),
                        ),
                        onPressed: () {
                          // chatroomScrollController.jumpToBottom();
                          chatroomScrollController.scrollToIndex(
                              chatroomController.messageLength -
                                  chatroomScrollController.messagesNotRead);
                        },
                        child: Text(
                          chatroomScrollController.messagesNotRead.toString() +
                              ' Unread',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // 顶部黑色线条
              Positioned(
                child: Container(height: 1.0, color: AppColors.divideLineColor),
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
                color: AppColors.messageBoxContainerBackgroundColor,
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 18.0, bottom: 28.0),
                alignment: Alignment.topCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: Get.height * 0.07 //最小高度为50像素
                            ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: AppColors.messageBoxBackgroundColor,

                            // border: Border.all(
                            //     width: 1.0, color: AppColors.messageBoxContainerBackground!),
                          ),
                          child: TextField(
                            minLines: 1,
                            maxLines: 5,
                            textAlignVertical: TextAlignVertical.center,
                            focusNode: chatroomScrollController.focusNode,
                            controller: chatroomController.messageController,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 送出訊息的按鈕，調用上面創的addMessage()函式
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: Get.height * 0.07 //最小高度为50像素
                          ),
                      child: GetBuilder<ChatroomController>(
                        builder: (_) {
                          return RoundedLoadingButton(
                              textStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              isLoading: chatroomController.isSendingMessage,
                              color: accentColor,
                              onPressed: () async {
                                await chatroomController.addMessage();
                              },
                              text: 'Send');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 底部黑色线条
            Positioned(
              child: Container(
                height: 1.5,
                color: AppColors.divideLineColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
