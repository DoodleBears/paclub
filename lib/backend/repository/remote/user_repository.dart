import 'package:get/get.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///能夠給其他Function調用Firebase所儲存的資料
// TODO: 支持用户上传头像
// TODO: 拆分 User
class UserRepository extends GetxController {
  static const String kAddUserFailed = 'add_user_failed';
  static const String kAddUserSuccessed = 'add_user_successed';
  static const String kUpdateUserSuccessed = 'update_user_successed';
  static const String kUpdateUserFailed = 'update_user_failed';

  static const String kAddFriendFailed = 'add_friend_failed';
  static const String kAddFriendSuccessed = 'add_friend_successed';
  static const String kUpdateFriendSuccessed = 'update_friend_successed';
  static const String kUpdateFriendFailed = 'update_friend_failed';

  static const String kGetFriendListFail = 'get_firend_list_fail';
  static const String kGetFriendListSuccess = 'get_firend_list_success';

  static const String kEnterChatroomFailed = 'enter_room_failed';
  static const String kEnterChatroomSuccessed = 'enter_room_successed';
  static const String kLeaveChatroomFailed = 'leave_room_failed';
  static const String kLeaveChatroomSuccessed = 'leave_room_successed';

  static const String kSearchUserFailed = 'search_user_failed';
  static const String kSearchUserSuccessed = 'search_user_successed';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

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

  /// NOTE: 添加新用户（设置信息）
  Future<AppResponse> addUser(UserModel userData) async {
    logger.i('addUser');
    // 判断是否要添加user
    bool isUserExist =
        await _usersCollection.doc(userData.uid).get().then((doc) {
      return doc.exists ? true : false;
    });

    if (isUserExist) {
      logger.w('用户已存在，无需再注册，更新上次登录时间');
      final Map<String, dynamic> updatedData = Map<String, dynamic>();
      updatedData['lastLoginAt'] = FieldValue.serverTimestamp();

      return _firestore
          .collection('users')
          .doc(userData.uid)
          .update(updatedData)
          .then((value) => AppResponse(kUpdateUserSuccessed, userData),
              onError: (e) {
        logger.e('更新用户信息失败，error: ' + e.runtimeType.toString());
        return AppResponse(kUpdateUserFailed, null);
      });
    } else {
      logger.w('用户不存在，添加用户到 collection:users');
      return _firestore
          .collection('users')
          .doc(userData.uid)
          .set(userData.toJson())
          .then((value) => AppResponse(kAddUserSuccessed, userData),
              onError: (e) {
        logger.e('添加用户失败，error: ' + e.runtimeType.toString());
        return AppResponse(kAddUserFailed, null);
      });
    }
  }

  // NOTE: 加某用户为好友
  Future<AppResponse> addFriend(
      {required String uid,
      required String friendUid,
      required String friendName}) async {
    Map<String, dynamic> map = Map();
    map['addAt'] = FieldValue.serverTimestamp();
    map['messageNotRead'] = 0;
    map['lastMessage'] = '';
    map['isInRoom'] = false;
    map['friendType'] = 'default';
    map['friendName'] = friendName;
    map['friendUid'] = friendUid;
    return _usersCollection
        .doc(uid)
        .collection('friends')
        .doc(friendUid)
        .set(map)
        .then(
      (_) => AppResponse(kAddFriendSuccessed, friendUid),
      onError: (e) {
        logger3.e(e);
        return AppResponse(kAddFriendFailed, null);
      },
    );
  }

  // NOTE: 获取好友列表（聊天列表）
  Stream<List<FriendModel>> getFriendListStream(String uid) {
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

  // NOTE: 进入房间
  Future<AppResponse> enterLeaveRoom({
    required String friendUid,
    required bool isEnterRoom,
  }) async {
    Map<String, dynamic> map = Map();
    map['isInRoom'] = isEnterRoom;
    map['messageNotRead'] = 0;
    return _usersCollection
        .doc(AppConstants.uuid)
        .collection('friends')
        .doc(friendUid)
        .update(map)
        .then(
      (_) {
        // 进入/离开房间成功
        logger.i(isEnterRoom ? '进入房间成功' : '离开房间成功');
        return AppResponse(
            isEnterRoom ? kEnterChatroomSuccessed : kLeaveChatroomSuccessed,
            friendUid);
      },
      onError: (e) {
        logger3.e(e);
        // 进入/离开房间失败
        return AppResponse(
            isEnterRoom ? kEnterChatroomFailed : kLeaveChatroomFailed, null);
      },
    );
  }

  // TODO: 模糊搜索，搜索多个用户
  Future<AppResponse> searchByName(String searchText) async {
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
        return AppResponse(kSearchUserSuccessed, list);
      },
      onError: (e) {
        logger3.e(e);
        return AppResponse(kSearchUserFailed, null);
      },
    );
  }
}
