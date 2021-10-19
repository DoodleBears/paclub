import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class ChatroomApi extends GetxController {
  final ChatroomRepository _chatroomRepository = Get.find<ChatroomRepository>();

  // MARK: GET 部分

  /// ## NOTE: 获取聊天室新消息的 Stream
  /// ## 传入参数
  /// - [chatroomId] 聊天室 ID
  /// - [enterRoomTimestamp] 进入聊天室的时间 用来作为分别「历史消息」和「最新消息」的判断
  ///
  /// ## 回传值
  /// - [Stream]
  /// - data: [List] 从当下开始的新消息 [ChatMessageModel] | 失败: null
  Stream<List<ChatMessageModel>> getNewMessageStream({
    required String chatroomId,
    required Timestamp enterRoomTimestamp,
  }) =>
      _chatroomRepository.getNewMessageStream(
          chatroomId: chatroomId, enterRoomTimestamp: enterRoomTimestamp);

  /// ## NOTE: 第一次获取聊天室历史消息
  /// ## 传入参数
  /// - [chatroomId] 聊天对象 uid
  /// - [enterRoomTimestamp] 进入聊天室的时间 用来作为分别「历史消息」和「最新消息」的判断
  /// - [limit] 获取历史消息的条数
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [List] 历史消息 [ChatMessageModel] | 失败: null
  Future<AppResponse> getOldMessagesFirstTime({
    required String chatroomId,
    required Timestamp enterRoomTimestamp,
    int limit = 30,
  }) async =>
      _chatroomRepository.getOldMessages(
        limit: limit,
        chatroomId: chatroomId,
        firstTime: true,
        enterRoomTimestamp: enterRoomTimestamp,
      );

  /// ## NOTE: 获取更多聊天室历史消息
  /// ## 传入参数
  /// - [chatroomId] 聊天对象 uid
  /// - [firstMessageDoc] 最早的历史消息的Doc, 用最早的历史消息作为起点拉取更早的历史消息
  /// - [limit] 获取历史消息的条数
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [List] 历史消息 [ChatMessageModel] | 失败: null
  Future<AppResponse> getMoreOldMessages(
          {required String chatroomId,
          required DocumentSnapshot firstMessageDoc,
          int limit = 30}) async =>
      _chatroomRepository.getOldMessages(
        chatroomId: chatroomId,
        firstTime: false,
        firstMessageDoc: firstMessageDoc,
        limit: limit,
      );

  // MARK: ADD 部分

  /// ## NOTE: 添加聊天室
  /// ## 传入参数
  /// - [chatroomId] 聊天对象 uid
  /// - [chatroomModel] 聊天室信息
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [List] 历史消息 [ChatMessageModel] | 失败: null
  Future<AppResponse> addChatroom({
    required ChatroomModel chatroomModel,
    required String chatroomId,
  }) async =>
      _chatroomRepository.addChatroom(
          chatroomModel: chatroomModel, chatroomId: chatroomId);

  /// ## NOTE: 添加消息到聊天室（发送消息）
  /// ## 传入参数
  /// - [chatroomId] 聊天室 ID
  /// - [chatWithUserUid] 聊天对象 UID
  /// - [chatMessageModel] 消息信息
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [List] 历史消息 [ChatMessageModel] | 失败: null
  Future<AppResponse> addMessage({
    required String chatroomId,
    required String chatWithUserUid,
    required ChatMessageModel chatMessageModel,
  }) async =>
      _chatroomRepository.addMessage(
          chatroomId: chatroomId,
          chatWithUserUid: chatWithUserUid,
          chatMessageModel: chatMessageModel);

  // MARK: 初始化
  @override
  void onInit() {
    logger.i('接入 ChatroomApi');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('断开 ChatroomApi');
    super.onClose();
  }
}
