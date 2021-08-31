import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatroomScroller extends GetxController {
  final ScrollController scrollController = ScrollController();
  int messagesNotRead = 0;
  bool isReadHistory = false;

  @override
  void onInit() async {
    logger.i('启用 ChatroomScroller');
    // 监听滚动条状态
    scrollController.addListener(() async {
      if (scrollController.offset <= messagesNotRead * 68.0 && isReadHistory) {
        logger.d('页面滚动-返回底部');
        isReadHistory = false;
        update();
        await Future.delayed(const Duration(milliseconds: 350));
        logger.d('清空未读消息数量: ' + messagesNotRead.toString());
        messagesNotRead = 0;
        update();
      }
      if (scrollController.offset > messagesNotRead * 68.0 && !isReadHistory) {
        logger.d('页面滚动-远离底部，开始显示新消息提醒');
        isReadHistory = true;
        update();
      }
    });

    super.onInit();
  }

  void newMessageJump(int newMessageNum) {
    logger3.i('新消息跳跃');
    scrollController.jumpTo(scrollController.offset + 68.0 * newMessageNum);
    update();
  }

  void scrollToBottom() {
    logger3.i('滚动至底部');
    scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    messagesNotRead = 0;
    update();
  }

  void jumpToBottom() {
    logger3.i('跳至底部');
    scrollController.jumpTo(0.0);
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomScroller');
    super.onClose();
  }
}
