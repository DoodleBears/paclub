import 'dart:async';

import 'package:get/get.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 什么时候用 static function？，当这个 function 跟其他数据 object 的 data 没有交互的时候
/// 很明显 database 这个 class 并没有 data 属性在内，只有 function
/// ！！！static function 不能 access object data

/// 能夠給其他Function調用Firebase所儲存的資料
/// TODO 编写 API 注释
class ChatroomRepository extends GetxController {
  static const String kAddChatroomFail = 'add_chatroom_fail';
  static const String kAddChatroomSuccess = 'add_chatroom_success';
  static const String kAddMessageFail = 'add_message_fail';
  static const String kAddMessageSuccess = 'add_message_success';
  static const String kNoMoreHistoryMessage = 'no_more_history_message';
  static const String kLoadHistoryMessageFail = 'load_history_message_fail';
  static const String kLoadHistoryMessageSuccess =
      'load_history_message_success';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _chatroomCollection =
      FirebaseFirestore.instance.collection('chatroom');

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

// FIXME 如何处理 Stream 的 error
  Stream<List<ChatroomModel>> getChatroomList(String uid) {
    logger.i('获取聊天列表资料 uid:' + uid);
    return _chatroomCollection
        .where('users', arrayContains: uid)
        .snapshots()
        .handleError((e) {
      toastBottom('Check your connection');
      logger.e(e.runtimeType);
    }).map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => ChatroomModel.fromDoucumentSnapshot(doc))
            .toList());
  }

  Future<AppResponse> addChatRoom(
      Map<String, dynamic> chatroomData, String chatroomId) async {
    return _chatroomCollection.doc(chatroomId).set(chatroomData).then(
      (_) async {
        return AppResponse(kAddChatroomSuccess, chatroomId);
      },
      onError: (e) {
        logger.e('添加聊天室失败, error: ' + e.runtimeType.toString());
        return AppResponse(kAddChatroomFail, null);
      },
    );
  }

// TODO Stream 类型的 return 需要包装为 AppResponse 吗？
// FIXME: 用 .snapshots() 是否不会有 error 需要catch
  Stream<List<ChatMessageModel>> getNewMessageStream(String chatroomId) {
    return _chatroomCollection
        .doc(chatroomId)
        .collection("chats")
        .where('time', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('time', descending: false)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => ChatMessageModel.fromDoucumentSnapshot(doc))
            .toList());
  }

  /// 用 Pagination（分页）来实作新 message 和旧 message 的获取
  /// 每次获取 [limit] 条消息
  Future<AppResponse> getOldMessages(String chatroomId,
      {DocumentSnapshot? firstMessageDoc,
      bool firstTime = false,
      int limit = 30}) async {
    assert(firstTime == true || firstMessageDoc != null,
        '请求更多历史消息需要有传入最旧(first)的消息做 pagination'); // 请求更多历史消息需要有传入最旧(first)的消息做 pagination

    // 基础 query, 参考教程: https://youtu.be/poqTHxtDXwU
    final baseQuery = _chatroomCollection
        .doc(chatroomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .limit(limit);

    // 如果是第一次拉取历史消息，如：刚进入聊天室（可以不用startbefore，所以区别开）
    if (firstTime) {
      try {
        List<ChatMessageModel> list = await baseQuery
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
    // 如果不是第一次拉取历史消息，如：加载更多历史消息（需要startbefore，所以区别开）

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

//TODO[epic=example] 这是标准的 Firestore 写法
  Future<AppResponse> addMessage(
      String chatroomId, ChatMessageModel chatMessageModel) async {
    return _chatroomCollection
        .doc(chatroomId)
        .collection("chats")
        .add(chatMessageModel.toJson())
        .timeout(const Duration(seconds: 15)) // 15秒钟超时限制
        .then(
      (docRef) {
        return AppResponse(kAddMessageSuccess, docRef);
      },
      onError: (e) {
        logger.e('添加新消息失败 : ' + e.runtimeType.toString());
        return AppResponse(kAddMessageFail, null);
      },
    );
  }
}
