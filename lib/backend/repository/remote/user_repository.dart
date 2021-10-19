import 'package:get/get.dart';
import 'package:paclub/constants/log_message.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///能夠給其他Function調用Firebase所儲存的資料
// TODO: 支持用户上传头像
class UserRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

// MARK: 初始化
  @override
  void onInit() {
    logger3.i('初始化 UserRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    if (useFirestoreEmulator) {
      _firestore.useFirestoreEmulator(localhost, firestorePort);
    }
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 UserRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    super.onClose();
  }

// MARK: GET 部分
  /// NOTE: 获取好友列表（聊天列表）
  Stream<List<FriendModel>> getFriendChatroomListStream({required String uid}) {
    logger.i('获取聊天列表资料 uid:' + uid);
    return _usersCollection
        .doc(uid)
        .collection('friends')
        .snapshots()
        .handleError((e) {
      logger.e('${e.runtimeType}: $kGetFriendListFail');
    }).map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => FriendModel.fromDoucumentSnapshot(doc))
            .toList());
  }

  /// NOTE: 获取未读消息数量
  Future<AppResponse> getFriendChatroomNotRead(
      {required String chatUserUid}) async {
    return await _usersCollection
        .doc(AppConstants.uuid)
        .collection('friends')
        .doc(chatUserUid)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        FriendModel friendModel = FriendModel.fromDoucumentSnapshot(doc);
        return AppResponse(
            kGetFirendChatroomNotReadSuccess, friendModel.messageNotRead);
      }
      logger3.e('获取未读消息失败: 不存在该 document');
      return AppResponse(kGetFriendChatroomNotReadFail, null);
    }, onError: (_) {
      logger3.e('获取未读消息失败');
      return AppResponse(kGetFriendChatroomNotReadFail, null);
    });
  }

  // TODO: 搜索列表支持无限加载（上滑加载）
  // TODO: 模糊搜索，搜索多个用户
  /// NOTE: 获取用户搜索结果(用于寻找用户-之后可添加好友)
  Future<AppResponse> getUserSearchResult({required String searchText}) async {
    return _usersCollection
        .where('displayName', isGreaterThanOrEqualTo: searchText)
        .limit(20)
        .get()
        .timeout(const Duration(seconds: 10))
        .then(
      (QuerySnapshot querySnapshot) {
        List<UserModel> list = querySnapshot.docs
            .map((doc) => UserModel.fromDoucumentSnapshot(doc))
            .toList();
        return AppResponse(kSearchUserSuccess, list);
      },
      onError: (e) {
        logger3.e(e);
        return AppResponse(kSearchUserFailed, null);
      },
    );
  }

// MARK: ADD 部分

  /// NOTE: 添加新用户（设置信息）
  Future<AppResponse> addUser({required UserModel userModel}) async {
    logger.i('addUser');
    // 判断是否要添加user
    bool isUserExist =
        await _usersCollection.doc(userModel.uid).get().then((doc) {
      return doc.exists ? true : false;
    });

    if (isUserExist) {
      logger.w('用户已存在，无需再注册，更新上次登录时间');
      final Map<String, dynamic> updatedData = Map<String, dynamic>();
      updatedData['lastLoginAt'] = FieldValue.serverTimestamp();

      return _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(updatedData)
          .then(
              (value) => AppResponse(kUpdateUserlastLoginAtSuccess, userModel),
              onError: (e) {
        logger.e('更新用户信息失败，error: ' + e.runtimeType.toString());
        return AppResponse(kUpdateUserlastLoginAtFailed, null);
      });
    } else {
      logger.w('用户不存在，添加用户到 collection:users');
      return _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toJson())
          .then((value) => AppResponse(kAddUserSuccess, userModel),
              onError: (e) {
        logger.e('添加用户失败，error: ' + e.runtimeType.toString());
        return AppResponse(kAddUserFailed, null);
      });
    }
  }

  /// NOTE: 加某用户为好友
  Future<AppResponse> addFriend(
      {required String uid,
      required String friendUid,
      required String friendName,
      required String friendType}) async {
    Map<String, dynamic> map = Map();
    map['addAt'] = FieldValue.serverTimestamp();
    map['messageNotRead'] = 0;
    map['lastMessage'] = '';
    // MARK: 当没有消息的时候，加好友的时间会作为显示在 聊天室列表最后消息的时间
    map['lastMessageTime'] = FieldValue.serverTimestamp();
    map['isInRoom'] = false;
    map['friendType'] = friendType;
    map['friendName'] = friendName;
    map['friendUid'] = friendUid;
    return _usersCollection
        .doc(uid)
        .collection('friends')
        .doc(friendUid)
        .set(map)
        .then(
      (_) => AppResponse(kAddFriendSuccess, friendUid),
      onError: (e) {
        logger3.e(e);
        return AppResponse(kAddFriendFailed, null);
      },
    );
  }

// MARK: UPDATE 部分

  /// NOTE: 但有新 message 发送到聊天室时，需要更新更新双方的 messageNotRead 和 lastMessage, lastMessageTime
  Future<AppResponse> updateFriendLastMessage({
    required String message,
    required String userUid,
    required String chatWithUserUid,
  }) async {
    logger.i('更新 uid: $chatWithUserUid 信息');
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
          return AppResponse(kUpdateFriendLastMessageSuccess, true);
        },
        onError: (e) {
          logger.e('更新LastMessage失败 : ${e.runtimeType}');
          return AppResponse(kUpdateFriendLastMessageFail, null);
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
            return AppResponse(kUpdateFriendLastMessageSuccess, true);
          } else {
            return AppResponse(kUpdateFriendLastMessageFail, null);
          }
        },
      );
    }
  }

  // MARK: 在当用户进入或离开某一个 Friend 的 Chatroom 时候触发（属于User行为，不属于User在Chatroom中的行为）
  /// NOTE: 进入房间
  Future<AppResponse> updateUserInRoom({
    required String friendUid,
    required bool isInRoom,
  }) async {
    Map<String, dynamic> map = Map();
    map['isInRoom'] = isInRoom;
    map['messageNotRead'] = 0;
    return _usersCollection
        .doc(AppConstants.uuid)
        .collection('friends')
        .doc(friendUid)
        .update(map)
        .then(
      (_) {
        // 进入/离开房间成功
        logger.i(isInRoom ? '进入房间成功' : '离开房间成功');
        return AppResponse(kUpdateUserInRoomSuccess, friendUid);
      },
      onError: (e) {
        logger3.e(e);
        // 进入/离开房间失败
        return AppResponse(kUpdateUserInRoomFailed, null);
      },
    );
  }
}
