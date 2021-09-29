import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroll_controller.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatroomController extends GetxController {
  final ChatroomScrollController chatroomScroller =
      Get.find<ChatroomScrollController>();
  final RefreshController refreshController = RefreshController();
  final ChatroomRepository chatroomRepository = Get.find<ChatroomRepository>();

  String message = '';
  String chatroomId = '';
  String userName = '';
  int messageLength = 0;
  int newMessageNum = 0;
  int oldMessageNum = 0;
  bool isSendingMessage = false;
  bool isHistoryExist = false;
  TextEditingController messageController = TextEditingController();
  // final ScrollController scrollController = ScrollController();

  final messageStream = <ChatMessageModel>[].obs;
  List<ChatMessageModel> oldMessageList = <ChatMessageModel>[];
  List<ChatMessageModel> newMessageList = <ChatMessageModel>[];

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
    messageStream
        .bindStream(chatroomRepository.getNewMessageStream(chatroomId));
    // 监听消息
    messageStream.listen(listenMessageStream);

    AppResponse appResponse =
        await chatroomRepository.getOldMessages(chatroomId, firstTime: true);
    logger.d(appResponse.message);

    if (appResponse.data != null) {
      List<ChatMessageModel> list = appResponse.data;
      oldMessageList.addAll(list);

      logger.d(list.length);
      if (appResponse.message == 'no_more_history_message') {
        isHistoryExist = false;
      } else {
        isHistoryExist = true;
      }
    }

    super.onInit();
  }

  void listenMessageStream(List<ChatMessageModel> list) async {
    newMessageNum = list.length - messageLength;
    newMessageList.addAll(list.skip(messageLength));
    newMessageList.forEach((item) {
      logger.d(item.message);
    });
    // 首次加载消息
    update();
    if (chatroomScroller.isReadHistory == true) {
      //如果在阅读历史消息，则添加增加未读消息数量
      chatroomScroller.messagesNotRead += newMessageNum;
      chatroomScroller.update(); // 更新显示未读消息数量
      logger.i('未读消息数量：' + chatroomScroller.messagesNotRead.toString());
    } else {
      chatroomScroller.messagesNotRead = 0;
    }
    messageLength = list.length; //更新当前消息长度
  }

  Future<void> loadMoreHistoryMessages({int limit = 20}) async {
    if (isHistoryExist == false) {
      toastTop('No more history');
      refreshController.loadNoData();
      return;
    }
    logger.i('开始加载 history');
    AppResponse appResponse = await chatroomRepository.getOldMessages(
      chatroomId,
      firstMessageDoc: oldMessageList.last.documentSnapshot,
      limit: limit,
    );
    logger.d(appResponse.message);
    if (appResponse.message == 'no_more_history_message') {
      isHistoryExist = false;
    }
    if (appResponse.data != null) {
      List<ChatMessageModel> list =
          List<ChatMessageModel>.from(appResponse.data);
      oldMessageList.addAll(list);

      oldMessageNum = list.length;
      logger.d('length: $oldMessageNum');
      update();
    } else {
      refreshController.loadFailed();
    }
    refreshController.loadComplete();

    return;
  }

  Future<void> addMessage() async {
    if (isSendingMessage) return;
    isSendingMessage = true;
    update();
    if (chatroomId.isEmpty) {
      logger.e('chatroomId 为空子串');
    }
    message = messageController.text;
    if (message.isNotEmpty) {
      AppResponse appResponse = await chatroomRepository.addMessage(
          chatroomId, ChatMessageModel(message, AppConstants.userName));
      if (appResponse.data != null) {
        logger.d(appResponse.message + ', 消息为: ' + message);
        messageController.clear(); // 成功发送消息，才清空消息框内容

      } else {
        toastBottom('sending fail: ${appResponse.message}');
        logger.e(appResponse.message);
      }
    }
    isSendingMessage = false;
    // update();
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomController');
    messageStream.close();
    super.onClose();
  }
}
