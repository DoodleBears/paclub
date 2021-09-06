import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatroomScrollController extends GetxController {
  final ScrollController scrollController =
      ScrollController(keepScrollOffset: false);
  bool isReadHistory = false; // 是否正在浏览历史记录
  int messagesNotRead = 0; // 未读消息数量
  bool isEdge = true; // 是否在边缘（顶部边缘，底部边缘）
  bool isTop = true; // 是否在顶部
  bool isCloseToButtom = true; // 是否接近底部
  bool isBottom = false; // 是否在底部
  bool isOut = false; // 是否出界（顶部之外，底部之外）
  double bottom = 0.0; // 记录ListView底部位置，方便跳转
  // double lastListHeight = 0.0;
  double keyboardHeight = 0.0; // 记录键盘高度

  final FocusNode focusNode = FocusNode();

  @override
  void onInit() async {
    logger.i('启用 ChatroomScroller');
    scrollController.addListener(() => listenScrolling()); // 监听滚动条状态
    focusNode.addListener(() => listenFocusNode()); // 监听TextField 输入框输入状态
    super.onInit();
  }

  void setReadNew() {
    bottom = scrollController.position.maxScrollExtent;
    if (isReadHistory == false) {
      isReadHistory = true; // 防止多次set
      update();
      logger0
          .d('页面滚动-远离底部，开始显示新消息提醒, isReadHistory:' + isReadHistory.toString());
    }
  }

  void setReadHistory() {
    if (isReadHistory) {
      isReadHistory = false; // 防止多次set
      logger0.d('页面滚动-返回底部, isReadHistory:' +
          isReadHistory.toString() +
          '\n清空未读消息数量: ' +
          messagesNotRead.toString());
      messagesNotRead = 0;
      update();
      // final ChatroomController chatroomController =
      //     Get.find<ChatroomController>();
      // chatroomController.update();
    }
  }

  void listenScrolling() {
    isEdge = scrollController.position.atEdge;
    isOut = scrollController.position.outOfRange;
    isTop = scrollController.offset <= 0;
    isCloseToButtom = scrollController.offset + 100.0 >
        scrollController.position.maxScrollExtent;
    isBottom = !isTop && (isCloseToButtom || isOut);

    // if (isListening) return;
    // 当出界或是在边缘，且不是在顶上，则说明 —— 滚动到底部，或是超出底部
    if (isBottom) {
      setReadHistory();
    } else {
      setReadNew();
    }
  }

  void listenFocusNode() {
    if (focusNode.hasFocus) {
      logger0.d('选中输入框: TextField got the focus，打断滚动动画');
      scrollController.jumpTo(scrollController.offset); // 打断滚动，如果用户在滚动过程中点击输入框
    } else {
      logger0.d('取消选中输入框: TextField lost the focus');
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(bottom,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    messagesNotRead = 0;
  }

  void jumpToBottom() {
    logger.w('bottom: $bottom');
    messagesNotRead = 0;

    scrollController.jumpTo(bottom);
    // focusNode.unfocus();
    isReadHistory = false;
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomScroller');
    scrollController.removeListener(() => listenScrolling()); // 监听滚动条状态
    focusNode.removeListener(() => listenFocusNode()); // 监听TextField 输入框输入状态
    super.onClose();
  }
}
