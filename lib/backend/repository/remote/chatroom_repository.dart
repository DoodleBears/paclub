import 'dart:async';

import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/chat_message_model.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/models/friend_model.dart';
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
  static const String kGetChatroomListFail = 'get_chatroom_list_fail';
  static const String kGetChatroomListSuccess = 'get_chatroom_list_success';
  static const String kUpdateChatroomListFail = 'update_chatroom_fail';
  static const String kUpdateChatroomListSuccess = 'update_chatroom_success';
  static const String kAddMessageFail = 'add_message_fail';
  static const String kAddMessageSuccess = 'add_message_success';
  static const String kNoMoreHistoryMessage = 'no_more_history_message';
  static const String kLoadHistoryMessageFail = 'load_history_message_fail';
  static const String kLoadHistoryMessageSuccess =
      'load_history_message_success';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _chatroomsCollection =
      FirebaseFirestore.instance.collection('chatrooms');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

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

  static String getChatRoomId(String strOne, String strTwo) {
    if (strOne.compareTo(strTwo) > 0) {
      return "$strTwo\_$strOne";
    } else {
      return "$strOne\_$strTwo";
    }
  }

  Stream<List<FriendModel>> getChatroomList(String uid) {
    logger.i('获取聊天列表资料 uid:' + uid);

    return _usersCollection
        .doc(uid)
        .collection('friends')
        .snapshots()
        .handleError((e) {
      toastCenter(kGetChatroomListFail);
      logger.e(e.runtimeType);
    }).map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => FriendModel.fromDoucumentSnapshot(doc))
            .toList());
  }

  Future<AppResponse> addChatRoom(
      ChatroomModel chatroomModel, String chatroomId) async {
    logger.i('添加聊天室 id: $chatroomId');

    return _chatroomsCollection
        .doc(chatroomId)
        .set(chatroomModel.toJson())
        .then(
      (_) async {
        final UserRepository userRepository = Get.find<UserRepository>();
        AppResponse appResponse_1 = await userRepository.addFriend(
          uid: chatroomModel.users[0],
          friendUid: chatroomModel.users[1],
          friendName: chatroomModel.usersName['${chatroomModel.users[1]}'],
        );

        AppResponse appResponse_2 = await userRepository.addFriend(
          uid: chatroomModel.users[1],
          friendUid: chatroomModel.users[0],
          friendName: chatroomModel.usersName['${chatroomModel.users[0]}'],
        );
        if (appResponse_1.data == null || appResponse_2.data == null) {
          return AppResponse(kAddChatroomFail, null);
        } else {
          logger.i('添加好友成功');

          return AppResponse(kAddChatroomSuccess, chatroomId);
        }
      },
      onError: (e) {
        logger.e('添加聊天室失败, error: ' + e.runtimeType.toString());
        return AppResponse(kAddChatroomFail, null);
      },
    );
  }

  Stream<List<ChatMessageModel>> getNewMessageStream(String chatroomId) {
    return _chatroomsCollection
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
    final baseQuery = _chatroomsCollection
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

  Future<AppResponse> updateUserFriend({
    required String message,
    required String chatWithUserUid,
    required String userUid,
  }) async {
    logger.i('更新Friend信息');
    Map<String, dynamic> updateData = Map();
    updateData['lastMessage'] = message;
    updateData['lastMessageTime'] = FieldValue.serverTimestamp();
    final DocumentReference documentReference = _usersCollection
        .doc(userUid)
        .collection('friends')
        .doc(chatWithUserUid);
    if (userUid == AppConstants.uuid) {
      return await _usersCollection
          .doc(userUid)
          .collection('friends')
          .doc(chatWithUserUid)
          .update(updateData)
          .then(
        (_) {
          return AppResponse(kUpdateChatroomListSuccess, true);
        },
        onError: (e) {
          logger.e('添加新消息失败 : ' + e.runtimeType.toString());
          return AppResponse(kAddMessageFail, null);
        },
      );
    } else {
      return await _firestore.runTransaction(
        (transaction) async {
          DocumentSnapshot documentSnapshot =
              await transaction.get(documentReference);
          // 用 transaction 来确保 read 到的 未读消息数量是最新的，正确的（在同时多人发消息的时候）
          if (documentSnapshot.exists) {
            // 找到 User
            FriendModel friendModel =
                FriendModel.fromDoucumentSnapshot(documentSnapshot);
            // 不是自己才更新 notRead
            updateData['messageNotRead'] = friendModel.messageNotRead + 1;
            transaction.update(documentReference, updateData);
            return AppResponse(kUpdateChatroomListSuccess, true);
          } else {
            return AppResponse(kUpdateChatroomListFail, null);
          }
        },
      );
    }

    // 自己肯定在房间
  }

//TODO[epic=example] 这是标准的 Firestore 写法
  Future<AppResponse> addMessage(String chatroomId,
      ChatMessageModel chatMessageModel, String chatUserUid) async {
    return _chatroomsCollection
        .doc(chatroomId)
        .collection("chats")
        .add(chatMessageModel.toJson())
        .then(
      (_) async {
        // 更新自己的user - friend 资料
        AppResponse appResponse_1 = await updateUserFriend(
          userUid: AppConstants.uuid,
          chatWithUserUid: chatUserUid,
          message: chatMessageModel.message,
        );
        // 更新friend 的 user - friend 资料
        AppResponse appResponse_2 = await updateUserFriend(
          userUid: chatUserUid,
          chatWithUserUid: AppConstants.uuid,
          message: chatMessageModel.message,
        );
        if (appResponse_1.data == null || appResponse_2.data == null) {
          return AppResponse(kAddMessageFail, null);
        } else {
          return AppResponse(kAddMessageSuccess, chatUserUid);
        }
      },
      onError: (e) {
        logger.e('添加新消息失败 : ' + e.runtimeType.toString());
        return AppResponse(kAddMessageFail, null);
      },
    );
  }
}
