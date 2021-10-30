import 'dart:async';
import 'package:get/get.dart';
import 'package:paclub/constants/log_message.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 什么时候用 static function？，当这个 function 跟其他数据 object 的 data 没有交互的时候
/// 很明显 database 这个 class 并没有 data 属性在内，只有 function
/// ！！！static function 不能 access object data

/// 能夠給其他Function調用Firebase所儲存的資料
class ChatroomRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _chatroomsCollection =
      FirebaseFirestore.instance.collection('chatrooms');

  // MARK: 初始化
  @override
  void onInit() {
    logger3.i('初始化 ChatroomRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    // 设定是否使用 Firebase Emulator
    if (useFirestoreEmulator) {
      _firestore.useFirestoreEmulator(localhost, firestorePort);
      _firestore.settings = Settings(
        host: '$localhost:$firestorePort',
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    super.onClose();
  }

  // MARK: GET 部分

  /// ## NOTE: 获取聊天室新消息的 Stream
  Stream<List<ChatMessageModel>> getNewMessageStream({
    required String chatroomId,
    required Timestamp enterRoomTimestamp,
  }) {
    return _chatroomsCollection
        .doc(chatroomId)
        .collection("chats")
        .where('time', isGreaterThanOrEqualTo: enterRoomTimestamp)
        .orderBy('time')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => ChatMessageModel.fromDoucumentSnapshot(doc))
            .toList());
  }

  /// ## NOTE: 获取聊天室历史消息
  /// 用 Pagination（分页）来实作新 message 和旧 message 的获取
  /// - 每次获取 [limit] 条消息
  /// - [firstTime] 区分是否为第一次获取历史消息
  Future<AppResponse> getOldMessages({
    required String chatroomId,
    required int limit,
    required bool firstTime,
    DocumentSnapshot? firstMessageDoc,
    Timestamp? enterRoomTimestamp,
  }) async {
    assert(
        (firstTime == true && enterRoomTimestamp != null) ||
            firstMessageDoc != null ||
            limit < 0,
        '请求更多历史消息需要有传入最旧(first)的消息做 pagination'); // 请求更多历史消息需要有传入最旧(first)的消息做 pagination

    // 基础 query, 参考教程: https://youtu.be/poqTHxtDXwU
    final baseQuery = _chatroomsCollection
        .doc(chatroomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .limit(limit);

    /// NOTE: 如果是第一次拉取历史消息，如：刚进入聊天室（可以不用startbefore，所以区别开）
    /// NOTE: 换句话说, 如果当前没有历史消息的话
    if (firstTime) {
      try {
        List<ChatMessageModel> list = await baseQuery
            .where('time', isLessThan: enterRoomTimestamp)
            .get(GetOptions(source: Source.server))
            .timeout(const Duration(seconds: 10)) // 10秒钟超时限制
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs
                .map((doc) => ChatMessageModel.fromDoucumentSnapshot(doc))
                .toList());
        return AppResponse(
            list.length < limit
                ? kNoMoreHistoryMessage
                : kLoadHistoryMessageSuccess,
            list);
      } on FirebaseException catch (e) {
        AppResponse appResponse = AppResponse(
            kLoadHistoryMessageFail, null, e.runtimeType.toString());
        logger3.w('errorCode: ${e.code}' + appResponse.toString());
        return appResponse;
      } catch (e) {
        AppResponse appResponse = AppResponse(
            kLoadHistoryMessageFail, null, e.runtimeType.toString());
        logger3.w(appResponse.toString());
        return appResponse;
      }
    }

    /// ## NOTE: 如果不是第一次拉取历史消息，如：加载更多历史消息（需要startbefore，所以区别开）
    try {
      List<ChatMessageModel> list = await baseQuery
          .startAfterDocument(firstMessageDoc!)
          .get(GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 10)) // 10秒钟超时限制
          .then((QuerySnapshot querySnapshot) => querySnapshot.docs
              .map((doc) => ChatMessageModel.fromDoucumentSnapshot(doc))
              .toList());
      // 获取成功，回传
      return AppResponse(
          list.length < limit
              ? kNoMoreHistoryMessage
              : kLoadHistoryMessageSuccess,
          list);
    } on FirebaseException catch (e) {
      AppResponse appResponse =
          AppResponse(kLoadHistoryMessageFail, null, e.runtimeType.toString());
      logger3.w('errorCode: ${e.code}' + appResponse.toString());
      return appResponse;
    } catch (e) {
      AppResponse appResponse =
          AppResponse(kLoadHistoryMessageFail, null, e.runtimeType.toString());
      logger3.w(appResponse.toString());
      return appResponse;
    }
  }

  /// ## NOTE: 获取聊天室资料
  Future<AppResponse> getChatroomInfo({
    required String chatroomId,
  }) async {
    logger.i('开始获取聊天室 Profile');

    return _chatroomsCollection.doc(chatroomId).get().then(
      (doc) {
        logger.i('成功获取聊天室 Profile');

        return AppResponse(
            kGetChatroomInfoSuccess, ChatroomModel.fromDoucumentSnapshot(doc));
      },
      onError: (e) {
        logger3.e('获取聊天室 Profile 失败');
        return AppResponse(kGetChatroomInfoFail, null);
      },
    );
  }

  // MARK: UPDATE 部分
  /// ## NOTE: 更新聊天室 Profile
  Future<AppResponse> updateChatroom({
    required Map<String, dynamic> updateMap,
    required String chatroomId,
  }) async {
    logger.i('更新聊天室 id: $chatroomId');

    return _chatroomsCollection.doc(chatroomId).update(updateMap).then(
      (_) async {
        logger.i('更新聊天室成功');
        return AppResponse(kUpdateChatroomInfoSuccess, chatroomId);
      },
      onError: (e) {
        logger.e('更新聊天室失败, error: ' + e.runtimeType.toString());
        return AppResponse(kUpdateChatroomInfoFail, null);
      },
    );
  }
  // MARK: ADD 部分

  /// ## NOTE: 添加聊天室
  /// TODO: 新增聊天室改为用 Document id 作为 document 的 field
  Future<AppResponse> addChatroom({
    required ChatroomModel chatroomModel,
  }) async {
    logger.i('开始添加聊天室');
    Map<String, dynamic> dataMap = chatroomModel.toJson();
    DocumentReference documentReference = _chatroomsCollection.doc();
    dataMap['chatroomId'] = documentReference.id;
    return documentReference.set(dataMap).then(
      (_) async {
        logger.i('添加聊天室成功: ${documentReference.id}');
        return AppResponse(kAddChatroomSuccess, documentReference.id);
      },
      onError: (e) {
        logger.e('添加聊天室失败, error: ' + e.runtimeType.toString());
        return AppResponse(kAddChatroomFail, null);
      },
    );
  }

  /// ## NOTE: 添加消息到聊天室（发送消息）
  Future<AppResponse> addMessage({
    required String chatroomId,
    required String chatWithUserUid,
    required ChatMessageModel chatMessageModel,
  }) async {
    return _chatroomsCollection
        .doc(chatroomId)
        .collection("chats")
        .add(chatMessageModel.toJson())
        .timeout(const Duration(seconds: 10))
        .then(
      (_) async {
        return AppResponse(kAddMessageSuccess, chatWithUserUid);
      },
      onError: (e) {
        logger.e('添加新消息失败 : ${e.runtimeType}');
        return AppResponse(kAddMessageFail, null);
      },
    );
  }
}
