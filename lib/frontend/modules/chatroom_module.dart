import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/api/chatroom_api.dart';
import 'package:paclub/backend/api/user_api.dart';
import 'package:paclub/constants/log_message.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class ChatroomModule extends GetxController {
  final ChatroomApi _chatroomApi = Get.find<ChatroomApi>();
  final UserApi _userApi = Get.find<UserApi>();

  Stream<List<ChatMessageModel>> getNewMessageStream({
    required String chatroomId,
    required Timestamp enterRoomTimestamp,
  }) =>
      _chatroomApi.getNewMessageStream(
          chatroomId: chatroomId, enterRoomTimestamp: enterRoomTimestamp);

  Future<AppResponse> getOldMessagesFirstTime({
    required String chatroomId,
    required Timestamp enterRoomTimestamp,
    int limit = 30,
  }) async =>
      _chatroomApi.getOldMessagesFirstTime(
          chatroomId: chatroomId, enterRoomTimestamp: enterRoomTimestamp);

  Future<AppResponse> getMoreOldMessages(
          {required String chatroomId,
          required DocumentSnapshot firstMessageDoc,
          int limit = 30}) async =>
      _chatroomApi.getMoreOldMessages(
          chatroomId: chatroomId, firstMessageDoc: firstMessageDoc);

  Future<AppResponse> getChatroomInfo({
    required String chatroomId,
  }) async =>
      _chatroomApi.getChatroomInfo(chatroomId: chatroomId);

  Future<AppResponse> updateChatroom({
    required Map<String, dynamic> updateMap,
    required String chatroomId,
  }) async =>
      _chatroomApi.updateChatroom(updateMap: updateMap, chatroomId: chatroomId);

  Future<AppResponse> addChatroom({
    required ChatroomModel chatroomModel,
    required String chatroomId,
  }) async =>
      _chatroomApi.addChatroom(
          chatroomModel: chatroomModel, chatroomId: chatroomId);

  Future<AppResponse> addMessage({
    required String chatroomId,
    required String chatWithUserUid,
    required ChatMessageModel chatMessageModel,
  }) async {
    // NOTE: 向聊天室 添加 Message
    AppResponse appResponseChat = await _chatroomApi.addMessage(
      chatroomId: chatroomId,
      chatWithUserUid: chatWithUserUid,
      chatMessageModel: chatMessageModel,
    );
    if (appResponseChat.data == null) {
      return appResponseChat;
    }

    // NOTE: 更新【自己】的 user - friend 资料
    AppResponse appResponseLastMessage1 =
        await _userApi.updateFriendLastMessage(
      userUid: AppConstants.uuid,
      chatWithUserUid: chatWithUserUid,
      message: chatMessageModel.message,
    );

    // NOTE: 更新【friend】 的 user - friend 资料
    AppResponse appResponseLastMessage2 =
        await _userApi.updateFriendLastMessage(
      userUid: chatWithUserUid,
      chatWithUserUid: AppConstants.uuid,
      message: chatMessageModel.message,
    );
    if (appResponseLastMessage1.data == null) {
      return appResponseLastMessage1;
    } else if (appResponseLastMessage2.data == null) {
      return appResponseLastMessage2;
    } else {
      return AppResponse(kUpdateFriendLastMessageSuccess, chatWithUserUid);
    }
  }

  // MARK: 初始化
  @override
  void onInit() {
    logger.i('调用 ChatroomModule');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('结束调用 ChatroomModule');
    super.onClose();
  }
}
