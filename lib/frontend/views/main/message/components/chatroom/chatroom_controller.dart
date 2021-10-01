import 'package:paclub/backend/repository/remote/user_repository.dart';
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
  final UserRepository userRepository = Get.find<UserRepository>();
  final ChatroomRepository chatroomRepository = Get.find<ChatroomRepository>();

  final ChatroomScrollController chatroomScroller =
      Get.find<ChatroomScrollController>();
  final RefreshController refreshController = RefreshController();
  static final switchMessageNum = 12;
  String chatroomId = '';
  String chatUserName = '';
  String chatUserUid = '';
  int messageNotRead = 0;
  bool isJumpBackShow = false;
  int newMessageNum = 0;
  int allMessageNum = 0;
  int skipMessageNum = 0;
  bool isOver12 = false;
  bool isLoadingHistory = false;
  bool isSendingMessage = false;
  bool isHistoryExist = true;
  Key centerKey = ValueKey('onelist'); // 用两个list，不同延伸方向，来解决加载旧消息和接收新消息
  TextEditingController messageTextFieldController = TextEditingController();

  final messageStream = <ChatMessageModel>[].obs;
  List<ChatMessageModel> oldMessageList = <ChatMessageModel>[];
  List<ChatMessageModel> newMessageList = <ChatMessageModel>[];

  @override
  void onInit() async {
    Map<String, dynamic> chatroomInfo = Get.arguments;
    this.chatroomId = chatroomInfo['chatroomId'];
    this.chatUserName = chatroomInfo['userName'];
    this.chatUserUid = chatroomInfo['userUid'];
    if (chatroomInfo.containsKey('messageNotRead')) {
      messageNotRead = chatroomInfo['messageNotRead'];
    } else {
      AppResponse appResponse =
          await chatroomRepository.getChatroomNotRead(chatUserUid);
      if (appResponse.data != null) {
        messageNotRead = appResponse.data;
      }
    }
    logger.i('启用 ChatroomController\n开始获取房间ID: $chatroomId 的消息');
    // 进入房间
    userRepository.enterLeaveRoom(friendUid: chatUserUid, isEnterRoom: true);

    // TODO: 拆分 DatabaseMethods 成 Module API 的请求

    // 绑定消息 Stream 到 Firebase 的数据库请求回传
    messageStream
        .bindStream(chatroomRepository.getNewMessageStream(chatroomId));
    // 监听消息
    messageStream.listen((list) => listenMessageStream(list));

    await loadMoreHistoryMessages(
        limit: messageNotRead > switchMessageNum
            ? messageNotRead
            : 30); // 首次加载历史记录

    super.onInit();
  }

  void listenMessageStream(List<ChatMessageModel> list) async {
    // logger.i('old: ${oldMessageList.length}\nnew: ${newMessageList.length}');
    // logger.i('all: $allMessageNum');

    if (oldMessageList.length + messageStream.length < switchMessageNum) {
      newMessageList = newMessageList = List.from(messageStream.reversed);
    } else if (isOver12 == false) {
      isOver12 = true;
      centerKey = ValueKey('twolist');
      newMessageList = List.from(messageStream);
      skipMessageNum = newMessageList.length;
      oldMessageList.insertAll(0, newMessageList.reversed);
      newMessageList = List.from(messageStream.skip(skipMessageNum));

      update();
    } else {
      newMessageList = List.from(messageStream.skip(skipMessageNum));
    }
    if (oldMessageList.length + messageStream.length >= switchMessageNum) {
      newMessageNum =
          oldMessageList.length + newMessageList.length - allMessageNum;
    }
    allMessageNum = oldMessageList.length + newMessageList.length;

    update();

    // 首次加载消息
    if (chatroomScroller.isReadHistory == true) {
      //如果在阅读历史消息，则添加增加未读消息数量
      chatroomScroller.currentMessageNotRead += newMessageNum;
      chatroomScroller.update(); // 更新显示未读消息数量
      logger.i('未读消息数量：' + chatroomScroller.currentMessageNotRead.toString());
    } else {
      chatroomScroller.currentMessageNotRead = 0;
    }
  }

  Future<void> loadMoreHistoryMessages({int limit = 30}) async {
    if (isLoadingHistory) return;
    if (isHistoryExist == false) {
      refreshController.loadNoData();
      return;
    }
    isLoadingHistory = true;
    update();
    logger.i('开始加载历史消息');
    AppResponse appResponse;
    // 当历史列表为空，有可能是第一次进入页面，或是网络重连后，再该页面刷新
    if (oldMessageList.isEmpty) {
      appResponse = await chatroomRepository.getOldMessages(
        chatroomId,
        firstTime: true,
        limit: limit,
      );
    } else {
      // 历史列表不为空，拉取更早的消息
      appResponse = await chatroomRepository.getOldMessages(
        chatroomId,
        firstMessageDoc: oldMessageList.last.documentSnapshot,
        limit: limit,
      );
    }
    if (appResponse.data != null) {
      if (appResponse.message == 'no_more_history_message') {
        isHistoryExist = false;
      }
      List<ChatMessageModel> list =
          List<ChatMessageModel>.from(appResponse.data);
      oldMessageList.addAll(list);
      if (oldMessageList.length >= switchMessageNum) {
        isOver12 = true;
      }
      // 更新总消息长度
      allMessageNum = oldMessageList.length + newMessageList.length;
      refreshController.loadComplete();
      if (messageNotRead >= oldMessageList.length &&
          messageNotRead > switchMessageNum) {
        isJumpBackShow = true;
      } else {
        isJumpBackShow = false;
      }
    } else {
      toastCenter('Check Internet\n${appResponse.message}');
      refreshController.loadFailed();
    }

    isLoadingHistory = false;
    update();

    return;
  }

  Future<void> addMessage() async {
    if (isSendingMessage) return;
    isSendingMessage = true;
    update(['chatSendingMessageField']);
    if (chatroomId.isEmpty) {
      logger.e('chatroomId 为空子串');
    }
    String message = messageTextFieldController.text;
    if (message.isNotEmpty) {
      AppResponse appResponse = await chatroomRepository.addMessage(chatroomId,
          ChatMessageModel(message, AppConstants.userName), chatUserUid);

      if (appResponse.data != null) {
        logger.d(appResponse.message + ', 消息为: ' + message);
        messageTextFieldController.clear(); // 成功发送消息，才清空消息框内容
      } else {
        toastCenter(appResponse.message);
        logger.e(appResponse.message);
      }
    }
    isSendingMessage = false;
    update(['chatSendingMessageField']);
  }

  void clearNotRead() {
    isJumpBackShow = false;
    update();
  }

  Future<void> enterLeaveRoom(bool isEnterRoom) async {
    userRepository.enterLeaveRoom(
        friendUid: chatUserUid, isEnterRoom: isEnterRoom);
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomController');
    // userRepository.enterLeaveRoom(friendUid: chatUserUid, isEnterRoom: false);
    messageStream.close();
    super.onClose();
  }
}
