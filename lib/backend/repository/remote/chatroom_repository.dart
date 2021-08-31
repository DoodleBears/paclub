import 'dart:async';

import 'package:get/get.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 什么时候用 static function？，当这个 function 跟其他数据 object 的 data 没有交互的时候
/// 很明显 database 这个 class 并没有 data 属性在内，只有 function
/// ！！！static function 不能 access object data

///能夠給其他Function調用Firebase所儲存的資料
class ChatroomRepository extends GetxController {
  static const String kAddChatroomFailedError = 'add_chatroom_failed';
  static const String kAddChatroomSuccessed = 'add_chatroom_successed';
  static const String kAddMessageFailedError = 'add_message_failed';
  static const String kAddMessageSuccessed = 'add_message_successed';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _chatroom;

  @override
  void onInit() {
    logger3.i('初始化 ChatroomRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    if (useFirestoreEmulator) {
      _firestore.useFirestoreEmulator(localhost, firestorePort);
      _firestore.settings = Settings(
        host: '$localhost:$firestorePort',
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }

    _chatroom = _firestore.collection('chatroom');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 ChatroomRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    super.onClose();
  }

  Stream<List<ChatroomModel>> getChatroomList(String uid) {
    logger.i('获取好友资料 uid:' + uid);
    return _chatroom.where('users', arrayContains: uid).snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => ChatroomModel.fromDoucumentSnapshot(doc))
            .toList());
  }

// TODO: 改用 chatRoomModel
  Future<AppResponse> addChatRoom(
      Map<String, dynamic> chatroomData, String chatroomId) async {
    return _chatroom
        .doc(chatroomId)
        // TODO set 和 add，set 会 overwrite，需要注意
        .set(chatroomData)
        .then(
      (_) => AppResponse(kAddChatroomSuccessed, chatroomId),
      onError: (e) {
        logger.e('添加聊天室失败, error: ' + e.runtimeType.toString());
        return AppResponse(kAddChatroomFailedError, null);
      },
    );
  }

// TODO Stream 类型的 return 需要包装为 AppResponse 吗？
// FIXME: 用 .snapshots() 是否不会有 error 需要catch
  Stream<List<ChatMessageModel>> getChats(String chatroomId) {
    return _chatroom
        .doc(chatroomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => ChatMessageModel.fromDoucumentSnapshot(doc))
            .toList());
  }

//TODO[epic=example] 这是标准的 Firestore 写法
  Future<AppResponse> addMessage(
      String chatRoomId, ChatMessageModel chatMessageModel) async {
    return _chatroom
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageModel.toJson())
        .then(
      (_) => AppResponse(kAddMessageSuccessed, chatRoomId),
      onError: (e) {
        logger.e(e.runtimeType.toString());
        return AppResponse(kAddMessageFailedError, null);
      },
    );
  }
}
