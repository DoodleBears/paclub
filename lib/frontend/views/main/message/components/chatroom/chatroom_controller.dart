import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paclub/frontend/modules/chatroom_module.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_scroll_controller.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatroomController extends GetxController {
  final UserModule _userModule = Get.find<UserModule>();
  final ChatroomModule _chatroomModule = Get.find<ChatroomModule>();
  final ChatroomScrollController chatroomScroller =
      Get.find<ChatroomScrollController>();
  final RefreshController refreshController = RefreshController();
  static final switchMessageNum = 12;
  late final ChatroomModel chatroomModel;
  String chatroomId = '';
  String chatUserName = '';
  String chatWithUserUid = '';
  String avatarURL = '';
  int messageNotRead = 0;

  /// 是否显示返回到上次阅读位置的按钮
  bool isOnInit = true;
  bool isJumpBackShow = false;
  bool isSendButtonShow = false;
  int newMessageNum = 0;
  int allMessageNum = 0;
  int skipMessageNum = 0;
  bool isOver12 = false;
  bool isLoadingHistory = false;
  bool isHistoryExist = true;
  Key centerKey = ValueKey('onelist'); // 用两个list，不同延伸方向，来解决加载旧消息和接收新消息
  TextEditingController messageTextFieldController = TextEditingController();

  // 进入房间的时间，在每次 controller 启用的时候初始化（用来确定历史消息和新消息的分界线）
  late final Timestamp enterRoomTimestamp;
  final messageStream = <ChatMessageModel>[].obs;
  List<ChatMessageModel> oldMessageList = <ChatMessageModel>[];
  List<ChatMessageModel> newMessageList = <ChatMessageModel>[];

  @override
  void onInit() async {
    logger.w('启用 ChatroomController');
    enterRoomTimestamp = Timestamp.now();
    await _getPageParameter();

    super.onInit();
  }

  @override
  void onReady() async {
    _updateFriendProfile();
    AppResponse appResponseChatroomInfo =
        await _chatroomModule.getChatroomInfo(chatroomId: chatroomId);
    if (appResponseChatroomInfo.data != null) {
      chatroomModel = appResponseChatroomInfo.data;
      _updateChatroomProfile();
    } else {
      toastTop(appResponseChatroomInfo.message);
    }
    // 绑定消息 Stream 到 Firebase 的数据库请求回传
    // 监听消息
    messageStream.listen((list) => listenNewMessageStream(list));

    await loadMoreHistoryMessages(
        limit: messageNotRead > switchMessageNum
            ? messageNotRead
            : 30); // 首次加载历史记录
    messageStream.bindStream(_chatroomModule.getNewMessageStream(
      chatroomId: chatroomId,
      enterRoomTimestamp: enterRoomTimestamp,
    ));
  }

  void webLoading() {
    chatroomScroller.jumpToTop();
    refreshController.requestLoading(
      curve: Curves.ease,
    );
  }

  Future<void> _getPageParameter() async {
    Map<String, dynamic> chatroomInfo = Get.arguments;
    this.chatroomId = chatroomInfo['chatroomId'];
    this.chatUserName = chatroomInfo['userName'];
    this.chatWithUserUid = chatroomInfo['userUid'];
    this.avatarURL = chatroomInfo['avatarURL'];
    // NOTE: 获取未读消息数量
    if (chatroomInfo.containsKey('messageNotRead')) {
      messageNotRead = chatroomInfo['messageNotRead'];
    } else {
      // MARK: 当从 搜索 界面进入聊天室的时候，需要从 server 获取未读消息数量
      AppResponse appResponseNotRead = await _userModule
          .getFriendChatroomNotRead(chatUserUid: chatWithUserUid);
      if (appResponseNotRead.data != null) {
        messageNotRead = appResponseNotRead.data;
      }
    }
    logger.i('开始获取房间ID: $chatroomId 的消息');
  }

  // NOTE: 之所以在这里更新用户信息
  // NOTE: 是因为当用户 A 更新用户名的时候，理论上需要更新 A 的朋友的 friends Collection 下面对应的 displayName, 这个 SQL 会非常耗时且消耗大、
  // NOTE: 通过是A的好友的用户进入聊天室
  Future<void> _updateFriendProfile() async {
    AppResponse appResponseUserProfile =
        await _userModule.getUserProfile(uid: chatWithUserUid);

    if (appResponseUserProfile.data != null) {
      UserModel friendModel = appResponseUserProfile.data;
      // NOTE: 进入房间
      Map<String, dynamic> updateMap = {
        'isInRoom': true,
        'messageNotRead': 0,
      };
      // NOTE: 更新 Friend 的头像 Link 和 displayName
      if (chatUserName != friendModel.displayName) {
        updateMap['friendName'] = friendModel.displayName;
        chatUserName = friendModel.displayName;
      }
      if (avatarURL != friendModel.avatarURL) {
        updateMap['avatarURL'] = friendModel.avatarURL;
        avatarURL = friendModel.avatarURL;
      }
      AppResponse appResponseUpdateFriendProfile =
          await _userModule.updateFriendProfile(
              friendUid: chatWithUserUid, updateMap: updateMap);
      if (appResponseUpdateFriendProfile.data == null) {
        update();
        toastTop(appResponseUpdateFriendProfile.message);
      }
    } else {
      toastTop(appResponseUserProfile.message);
    }
  }

  void _updateChatroomProfile() {
    if (chatroomModel.usersName[chatWithUserUid] != chatUserName) {
      Map<String, dynamic> usersName = chatroomModel.usersName;
      usersName[chatWithUserUid] = chatUserName;

      Map<String, dynamic> updateMap = {
        'usersName': usersName,
      };
      _chatroomModule.updateChatroom(
          chatroomId: chatroomId, updateMap: updateMap);
    }
  }

  // NOTE: 监听新消息
  void listenNewMessageStream(List<ChatMessageModel> list) async {
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

  // NOTE: 加载更多历史消息
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
    // NOTE: 当历史列表为空，有可能是第一次进入页面，或是网络重连后，再该页面刷新
    if (oldMessageList.isEmpty) {
      appResponse = await _chatroomModule.getOldMessagesFirstTime(
        chatroomId: chatroomId,
        enterRoomTimestamp: enterRoomTimestamp,
        limit: limit,
      );
    } else {
      // NOTE: 历史列表不为空, 则基于最早的历史消息, 作为起点, 拉取更早的消息
      appResponse = await _chatroomModule.getMoreOldMessages(
        chatroomId: chatroomId,
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
      if (isOnInit == true) {
        isOnInit = false;
      }
    } else {
      toastCenter('Check Internet\n${appResponse.message}');
      refreshController.loadFailed();
    }

    isLoadingHistory = false;
    update();

    return;
  }

  // NOTE: 发送消息
  Future<void> addMessage() async {
    String message = messageTextFieldController.text;
    messageTextFieldController.clear(); // 成功发送消息，才清空消息框内容
    toggleSendButton('');
    if (message.isNotEmpty) {
      AppResponse appResponse = await _chatroomModule.addMessage(
        chatroomId: chatroomId,
        chatMessageModel:
            ChatMessageModel(message: message, sendByUid: AppConstants.uuid),
        chatWithUserUid: chatWithUserUid,
      );

      if (appResponse.data != null) {
        logger.d(appResponse.message + ', 消息为: ' + message);
      } else {
        toastCenter(appResponse.message);
        logger.e(appResponse.message);
        // 回复发送失败的消息
        messageTextFieldController.text = message;
      }
    }
  }

  // NOTE: 切换发送按钮的样式（在消息发送栏没有消息的时候，显示 + Icon；消息发送栏有消息的时候显示 send）
  void toggleSendButton(String text) {
    // logger.d(text);
    if (isSendButtonShow == false) {
      if (text != '') {
        isSendButtonShow = true;
        update(['send button']);
      }
    } else {
      if (text == '' || text.isEmpty) {
        isSendButtonShow = false;
        update(['send button']);
      }
    }
  }

  void clearNotRead() {
    isJumpBackShow = false;
    update();
  }

  // NOTE: 进出房间的时候，要更新 Firebase 的 isInRoom 的 Value 用于判断是否在房间
  Future<void> enterLeaveRoom(bool isEnterRoom) async {
    _userModule.updateUserInRoom(
        friendUid: chatWithUserUid, isInRoom: isEnterRoom);
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomController');
    messageStream.close();
    super.onClose();
  }
}
