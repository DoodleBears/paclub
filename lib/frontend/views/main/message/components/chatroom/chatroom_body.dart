import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/auth/login/components/components.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroll_controller.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/helper/chatroom_helper.dart';
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

class _ChatroomBodyState extends State<ChatroomBody> with WidgetsBindingObserver {
  final ChatroomController chatroomController = Get.find<ChatroomController>();
  final ChatroomScrollController chatroomScrollController = Get.find<ChatroomScrollController>();
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

  ///  在聊天室的时候，若App生命周期发生变化，需要做出isInRoom的设定，暂停App即算离开房间
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print('didChangeAppLifecycleState');
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          chatroomController.enterRoom();
          // print('AppLifecycleState.resumed');
          break;
        case AppLifecycleState.inactive:
          // print('AppLifecycleState.inactive');
          chatroomController.leaveRoom();
          break;
        case AppLifecycleState.paused:
          // print('AppLifecycleState.paused');
          chatroomController.leaveRoom();

          break;
        case AppLifecycleState.detached:
          // print('AppLifecycleState.detached');
          chatroomController.leaveRoom();
          break;
      }
    });
  }

  // 每次 重建ListView（一般是有新消息进入，则会重新计算高度）
  afterBuild() {
    if (chatroomScrollController.scrollController.hasClients) {
      // logger.e(
      //     'extentAfter: ${chatroomScrollController.scrollController.position.extentAfter}');

      /// 在读最新消息(即在聊天室底部)，直接加载最新消息，划入动画
      if (chatroomScrollController.isReadHistory == false) {
        logger.e('新消息渲染');
        chatroomScrollController.isAutoScrolling = true; // 防止自动滚动的时候，切换历史消息阅读状态
        Future.delayed(const Duration(milliseconds: 300),
            () => chatroomScrollController.isAutoScrolling = false);

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
            // alignment: Alignment.topCenter,
            children: [
              // 消息
              Container(
                color: AppColors.chatBackgroundColor,
                child: GetBuilder<ChatroomController>(
                  builder: (_) {
                    logger3.i('重建 ListView,length: ' +
                        (chatroomController.newMessageList.length +
                                chatroomController.oldMessageList.length)
                            .toString());

                    // 有新消息的时候才会触发，因为ListView.itemCount改变，导致GetBuilder重新渲染
                    WidgetsBinding.instance!.addPostFrameCallback((_) => afterBuild());
                    return chatroomController.isOnInit
                        ? Center(
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : Scrollbar(
                            child: SmartRefresher(
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

                                      bool isSendByMe = AppConstants.uuid ==
                                          chatroomController.newMessageList[index].sendByUid;

                                      // 如果两条消息之间跨度大
                                      Timestamp previous;
                                      String previousSendByUid;
                                      Timestamp sendTime =
                                          chatroomController.newMessageList[index].time;
                                      bool isDividerShow = false;

                                      // 是否总消息数量超过阈值
                                      if (chatroomController.allMessageNum >
                                          ChatroomController.switchMessageNum) {
                                        // 是第一条新消息
                                        if (index == 0) {
                                          // 有历史消息
                                          if (chatroomController.oldMessageList.isNotEmpty) {
                                            previous = chatroomController.oldMessageList[0].time;
                                            previousSendByUid =
                                                chatroomController.oldMessageList[0].sendByUid;
                                          } else {
                                            // 没有历史消息
                                            previous =
                                                chatroomController.newMessageList[index].time;
                                            previousSendByUid =
                                                chatroomController.newMessageList[index].sendByUid;
                                            isDividerShow = true;
                                          }
                                        } else {
                                          previous =
                                              chatroomController.newMessageList[index - 1].time;
                                          previousSendByUid = chatroomController
                                              .newMessageList[index - 1].sendByUid;
                                        }
                                      } else {
                                        // 是第一条新消息
                                        if (index + 1 == chatroomController.newMessageList.length) {
                                          // 有历史消息
                                          if (chatroomController.oldMessageList.isNotEmpty) {
                                            previous = chatroomController.oldMessageList[0].time;
                                            previousSendByUid =
                                                chatroomController.oldMessageList[0].sendByUid;
                                          } else {
                                            // 没有历史消息
                                            previous =
                                                chatroomController.newMessageList[index].time;
                                            previousSendByUid = '';
                                            isDividerShow = true;
                                          }
                                        } else {
                                          previous =
                                              chatroomController.newMessageList[index + 1].time;
                                          previousSendByUid = chatroomController
                                              .newMessageList[index + 1].sendByUid;
                                        }
                                      }

                                      if (isDividerShow == false) {
                                        isDividerShow = isChatMessageDividerShow(
                                          current: chatroomController.newMessageList[index].time,
                                          previous: previous,
                                        );
                                      }
                                      bool isAvatarShowValue = isAvatarShow(
                                          current: sendTime,
                                          previous: previous,
                                          currentSendByUid:
                                              chatroomController.newMessageList[index].sendByUid,
                                          previousSendByUid: previousSendByUid);

                                      Widget child = ChatroomMessageTile(
                                        isAvatarShow: isAvatarShowValue,
                                        friendUid: chatroomController.chatWithUserUid,
                                        friendAvatarURL: chatroomController.avatarURL,
                                        sendTime: sendTime,
                                        senderName: isSendByMe
                                            ? AppConstants.userName
                                            : chatroomController.chatroomModel.usersName[
                                                chatroomController.newMessageList[index].sendByUid],
                                        message: chatroomController.newMessageList[index].message,
                                        sendByMe: isSendByMe,
                                      );

                                      if (isDividerShow) {
                                        // 显示分隔日期
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                                              child: LineDivider(
                                                lineColor: Colors.grey,
                                                padding:
                                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Text(
                                                  chatMessageDividerFormatTime(
                                                    current: Timestamp.now(),
                                                    previous: chatroomController
                                                        .newMessageList[index].time,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child,
                                          ],
                                        );
                                      }
                                      return child;
                                    }, childCount: chatroomController.newMessageList.length),
                                  ),
                                  SliverList(
                                    // 历史消息
                                    key: chatroomController.centerKey,
                                    delegate: SliverChildBuilderDelegate(
                                      (_, index) {
                                        bool isSendByMe = AppConstants.uuid ==
                                            chatroomController.oldMessageList[index].sendByUid;

                                        // 如果两条消息之间跨度大
                                        Timestamp previous;
                                        bool isDividerShow = false;
                                        String previousSendByUid;
                                        String dividerText = '';
                                        if (index == chatroomController.messageNotRead - 1 &&
                                            chatroomController.messageNotRead > 12) {
                                          isDividerShow = true;
                                          dividerText = '上次阅读位置';
                                          previousSendByUid = '';
                                          previous = chatroomController.oldMessageList[index].time;
                                        } else {
                                          dividerText = chatMessageDividerFormatTime(
                                            current: Timestamp.now(),
                                            previous: chatroomController.oldMessageList[index].time,
                                          );

                                          if (index + 1 <
                                              chatroomController.oldMessageList.length) {
                                            isDividerShow = isChatMessageDividerShow(
                                              current:
                                                  chatroomController.oldMessageList[index].time,
                                              previous:
                                                  chatroomController.oldMessageList[index + 1].time,
                                            );
                                            previous =
                                                chatroomController.oldMessageList[index + 1].time;
                                            previousSendByUid = chatroomController
                                                .oldMessageList[index + 1].sendByUid;
                                          } else {
                                            // 如果没有历史记录了，则显示最旧消息的Time
                                            isDividerShow = true;
                                            previous =
                                                chatroomController.oldMessageList[index].time;
                                            previousSendByUid = '';
                                          }
                                        }
                                        bool isAvatarShowValue = isAvatarShow(
                                            current: chatroomController.oldMessageList[index].time,
                                            previous: previous,
                                            currentSendByUid:
                                                chatroomController.oldMessageList[index].sendByUid,
                                            previousSendByUid: previousSendByUid);

                                        Widget child = ChatroomMessageTile(
                                          isAvatarShow: isAvatarShowValue,
                                          friendUid: chatroomController.chatWithUserUid,
                                          friendAvatarURL: chatroomController.avatarURL,
                                          sendTime: chatroomController.oldMessageList[index].time,
                                          senderName: isSendByMe
                                              ? AppConstants.userName
                                              : chatroomController.chatroomModel.usersName[
                                                  chatroomController
                                                      .oldMessageList[index].sendByUid],
                                          message: chatroomController.oldMessageList[index].message,
                                          sendByMe: isSendByMe,
                                        );

                                        if (isDividerShow) {
                                          bool isLastTimeRead = dividerText == '上次阅读位置';
                                          // 显示分隔日期
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 24.0),
                                                child: LineDivider(
                                                  lineColor:
                                                      isLastTimeRead ? accentColor : Colors.grey,
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                  child: Text(
                                                    dividerText,
                                                    style: TextStyle(
                                                      color: isLastTimeRead
                                                          ? accentColor
                                                          : Colors.grey,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          isLastTimeRead ? FontWeight.bold : null,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              child,
                                            ],
                                          );
                                        }

                                        return child;
                                      },
                                      childCount: chatroomController.oldMessageList.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),

              // 未读消息 & 回到底部
              GetBuilder<ChatroomScrollController>(
                builder: (_) {
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                    bottom: chatroomScrollController.isReadHistory ? 4.0 : -60.0,
                    right: 16.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2.0,
                        primary: AppColors.chatroomNotReadButtonColor,
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        minimumSize: Size(30.0, 40.0),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                        width: chatroomScrollController.currentMessageNotRead == 0 ? 36.0 : 70.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Center(
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 32.0,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: chatroomScrollController.currentMessageNotRead != 0,
                              child: Flexible(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    chatroomScrollController.currentMessageNotRead > 99
                                        ? '99+'
                                        : '${chatroomScrollController.currentMessageNotRead}',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        chatroomScrollController.jumpToBottom();
                      },
                    ),
                  );
                },
              ),
              // 顶部黑色线条
              Positioned(
                child: Container(height: 1.0, color: AppColors.divideLineColor),
              ),
              // 未读消息 & 回到上次阅读
              GetBuilder<ChatroomController>(
                builder: (_) {
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                    right: 0.0,
                    top: chatroomController.messageNotRead == 0 ||
                            chatroomController.isJumpBackShow == false
                        ? -100.0
                        : 14.0,
                    child: Visibility(
                      visible: chatroomController.isJumpBackShow,
                      child: Dismissible(
                        key: ValueKey('Back to Unread'),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          chatroomController.clearNotRead();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 2.0,
                              primary: AppColors.chatroomNotReadButtonColor,
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_drop_up_rounded,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    chatroomController.messageNotRead > 99
                                        ? '99+'
                                        : '${chatroomController.messageNotRead}',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              chatroomController.clearNotRead();
                              chatroomScrollController.jumpToTop();
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                color: AppColors.messageSendingContainerBackgroundColor,
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18.0, bottom: 28.0),
                alignment: Alignment.topCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: Get.height * 0.07 //最小高度为50像素
                            ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: AppColors.messageSendingTextFieldBackgroundColor,

                            // border: Border.all(
                            //     width: 1.0, color: AppColors.messageBoxContainerBackground!),
                          ),
                          child: TextField(
                            minLines: 1,
                            maxLines: 5,
                            textAlignVertical: TextAlignVertical.center,
                            focusNode: chatroomScrollController.focusNode,
                            cursorColor: accentColor,
                            cursorHeight: 24.0,
                            controller: chatroomController.messageTextFieldController,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: chatroomController.toggleSendButton,
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
                        id: 'send button',
                        builder: (_) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: accentColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                            ),
                            onPressed: () async {
                              if (chatroomController.isSendButtonShow) {
                                await chatroomController.addMessage();
                              } else {
                                // 没有内容的时候
                              }
                            },
                            child: chatroomController.isSendButtonShow
                                ? Text(
                                    'Send',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 32.0,
                                  ),
                          );
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
