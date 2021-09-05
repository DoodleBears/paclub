import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_controller.dart';
import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatroomScrollController extends GetxController {
  final ScrollController scrollController =
      ScrollController(keepScrollOffset: false);
  // 通过检测是否在底部，来判断是否在读历史消息
  bool isReadHistory = false;
  int messagesNotRead = 0;
  bool isEdge = true;
  bool isTop = true;
  bool isOut = false;
  bool isListening = false;
  double shift = 0.0;

  @override
  void onInit() async {
    logger.i('启用 ChatroomScroller');
    scrollController.addListener(() => listenScrolling()); // 监听滚动条状态
    super.onInit();
  }

  void listenScrolling() async {
    isEdge = scrollController.position.atEdge;
    isTop = scrollController.offset <= 0;
    isOut = scrollController.position.outOfRange;

    // if (isListening) return;
    // 当出界或是在边缘，且不是在顶上，则说明 —— 滚动到底部，或是超出底部
    if (isTop) {
      if (isReadHistory) {
        isReadHistory = false;
        logger0.d('页面滚动-返回底部, isReadHistory:' +
            isReadHistory.toString() +
            '\n清空未读消息数量: ' +
            messagesNotRead.toString());
        messagesNotRead = 0;
        update();
        final ChatroomController chatroomController =
            Get.find<ChatroomController>();
        chatroomController.update();
      }
    } else {
      if (isReadHistory == false) {
        isReadHistory = true;
        logger0.d(
            '页面滚动-远离底部，开始显示新消息提醒, isReadHistory:' + isReadHistory.toString());
        update();
      }
    }
    isListening = false;
  }

  void scrollToBottom() {
    scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic);
    messagesNotRead = 0;
  }

  void jumpToBottom() {
    messagesNotRead = 0;
    scrollController.jumpTo(0.0);
    isReadHistory = false;
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomScroller');
    super.onClose();
  }
}
