import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroller.dart';
import 'package:paclub/helper/constants.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatroomController extends GetxController {
  final ChatroomScroller chatroomScroller = Get.find<ChatroomScroller>();
  final ChatroomRepository chatroomRepository = Get.find<ChatroomRepository>();

  String message = '';
  String chatroomId = '';
  String userName = '';
  int messageLength = 0;
  int newMessageNum = 0;
  // int messagesNotRead = 0;
  // bool isNewMessageNotify = false;

  TextEditingController messageController = TextEditingController();
  // final ScrollController scrollController = ScrollController();

  final messageStream = <ChatMessageModel>[].obs;

  @override
  void onInit() async {
    logger.i('启用 ChatroomController');
    // 监听滚动条状态
    Map<String, dynamic> chatroomInfo = Get.arguments;
    this.chatroomId = chatroomInfo['chatroomId'];
    this.userName = chatroomInfo['userName'];
    logger.i('开始获取房间ID:' + chatroomId + ' 的消息');

    // 绑定消息 Stream 到 Firebase 的数据库请求回传

    // TODO: 拆分 DatabaseMethods 成 Module API 的请求

    messageStream.bindStream(chatroomRepository.getChats(chatroomId));
    chatroomRepository.getChats(chatroomId).listen((list) {
      newMessageNum = list.length - messageLength;
      chatroomScroller.messagesNotRead += newMessageNum;
      logger.i('未读条数为：' + chatroomScroller.messagesNotRead.toString());
      if (list.isEmpty) return;
      // 首次加载
      if (messageLength == 0) {
        update();
        chatroomScroller.scrollToBottom();
      } else if (messageLength > 0) {
        // 处理其他人发消息的情况
        if (list.first.sendBy != Constants.myName) {
          chatroomScroller.newMessageJump(newMessageNum);
          if (!chatroomScroller.isReadHistory) {
            // 不处于查看历史消息状态时，产生滚动动画
            chatroomScroller.scrollToBottom();
          }
        } else if (!chatroomScroller.isReadHistory) {
          // 自己发消息，且不是在浏览历史记录时
          update();
          chatroomScroller.newMessageJump(newMessageNum);
        }
      }
      messageLength = list.length;
    });

    super.onInit();
  }

  Future<void> addMessage() async {
    if (chatroomId.isEmpty) {
      logger.e('chatroomId 为空子串');
    }
    message = messageController.text;
    if (message.isNotEmpty) {
      AppResponse appResponse = await chatroomRepository.addMessage(
          chatroomId, ChatMessageModel(message, Constants.myName));
      if (appResponse.data != null) {
        logger.d(appResponse.message + ', 消息为: ' + message);
        messageController.clear(); // 成功发送消息，才清空消息框内容
        if (chatroomScroller.isReadHistory) {
          // 查看历史消息时，不会画面导致滚动
          chatroomScroller.newMessageJump(newMessageNum);
          update();
        } else {
          // 不处于查看历史消息状态时
          chatroomScroller.scrollToBottom();
          // 如果每次发新消息不滚动到底部，则选中下面的
          // chatroomScroller.newMessageJump(newMessageNum);
        }
      } else {
        logger.e(appResponse.message);
      }
    }
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomController');
    super.onClose();
  }
}
