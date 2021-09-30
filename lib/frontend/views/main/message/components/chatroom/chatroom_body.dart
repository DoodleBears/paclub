import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/auth/login/components/components.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroll_controller.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  // 每次 重建ListView（一般是有新消息进入，则会重新计算高度）
  afterBuild() {
    if (chatroomScrollController.scrollController.hasClients) {
      // logger.e(
      //     'extentAfter: ${chatroomScrollController.scrollController.position.extentAfter}');

      /// 在读最新消息(即在聊天室底部)，直接加载最新消息，划入动画
      if (chatroomScrollController.isReadHistory == false) {
        logger.e('新消息渲染');

        chatroomScrollController.scrollToBottom();
        // chatroomScrollController
        //     .scrollToIndex(chatroomController.newMessageNum);
      }
    } else {
      logger.e('无法找到controller');
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('渲染 ChatRoomBody');
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                color: AppColors.chatBackgroundColor,
                child: GetBuilder<ChatroomController>(
                  builder: (_) {
                    logger3.i('重建 ListView,length: ' +
                        (chatroomController.newMessageList.length +
                                chatroomController.oldMessageList.length)
                            .toString());

                    // 有新消息的时候才会触发，因为ListView.itemCount改变，导致GetBuilder重新渲染
                    WidgetsBinding.instance!
                        .addPostFrameCallback((_) => afterBuild());
                    return SmartRefresher(
                      // 这里 PullDown对应 onRefresh()，但这里我们reverse了，所以不需要用到
                      // 而是要用 PullUp和对应的 onLoading()
                      enablePullDown: false,
                      header: ClassicHeader(
                        completeIcon: SizedBox.shrink(),
                        completeText: '',
                      ),
                      enablePullUp: true,
                      controller: chatroomController.refreshController,
                      onLoading: chatroomController.loadMoreHistoryMessages,
                      footer: ClassicFooter(
                        textStyle: TextStyle(
                          fontSize: 18.0,
                        ),
                        loadingText: '',
                        spacing: 0.0,
                        loadingIcon: SizedBox(
                          height: 28.0,
                          width: 28.0,
                          child: CircularProgressIndicator(
                            color: accentColor,
                            strokeWidth: 6.0,
                            // color: AppColors.refreshIndicatorColor,
                          ),
                        ),
                        loadStyle: LoadStyle.ShowWhenLoading,
                        height: 60.0,
                      ),
                      child: CustomScrollView(
                        // anchor: 0.8,
                        reverse: true,
                        center: chatroomController.allMessageNum <
                                ChatroomController.switchMessageNum
                            ? null
                            : chatroomController.centerKey,
                        physics: chatroomController.isLoadingHistory
                            ? const NeverScrollableScrollPhysics() // 防止加载历史记录时候滚动跳动
                            : const BouncingScrollPhysics(),
                        controller: chatroomScrollController.scrollController,
                        slivers: <Widget>[
                          SliverList(
                            // 新消息
                            delegate: SliverChildBuilderDelegate((_, index) {
                              // logger0.d('newindex: $index');

                              bool isSendByMe = AppConstants.userName ==
                                  chatroomController
                                      .newMessageList[index].sendBy;

                              return ChatroomMessageTile(
                                senderName: chatroomController
                                    .newMessageList[index].sendBy,
                                message: chatroomController
                                    .newMessageList[index].message,
                                sendByMe: isSendByMe,
                              );
                            },
                                childCount:
                                    chatroomController.newMessageList.length),
                          ),
                          SliverList(
                            // 历史消息
                            key: chatroomController.centerKey,
                            delegate: SliverChildBuilderDelegate(
                              (_, index) {
                                // logger0.d('newindex: $index');
                                if (index ==
                                    chatroomController.oldMessageList.length -
                                        1) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: ChatroomMessageTile(
                                      senderName: chatroomController
                                          .oldMessageList[index].sendBy,
                                      message: chatroomController
                                          .oldMessageList[index].message,
                                      sendByMe: AppConstants.userName ==
                                          chatroomController
                                              .oldMessageList[index].sendBy,
                                    ),
                                  );
                                }

                                return ChatroomMessageTile(
                                  senderName: chatroomController
                                      .oldMessageList[index].sendBy,
                                  message: chatroomController
                                      .oldMessageList[index].message,
                                  sendByMe: AppConstants.userName ==
                                      chatroomController
                                          .oldMessageList[index].sendBy,
                                );
                              },
                              childCount:
                                  chatroomController.oldMessageList.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

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
                          chatroomScrollController.jumpToBottom();
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
                            controller:
                                chatroomController.messageTextFieldController,
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
                        minHeight: Get.height * 0.07, //最小高度为50像素
                      ),
                      child: GetBuilder<ChatroomController>(
                        assignId: true,
                        id: 'chatSendingMessageField', // 防止 ListView 多刷新一次
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
