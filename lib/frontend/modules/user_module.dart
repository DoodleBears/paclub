import 'package:get/get.dart';
import 'package:paclub/backend/api/user_api.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class UserModule extends GetxController {
  final UserApi _userApi = Get.find<UserApi>();

  Stream<List<FriendModel>> getFriendChatroomListStream(String uid) =>
      _userApi.getFriendChatroomListStream(uid: uid);

  Future<AppResponse> getFriendChatroomNotRead(
          {required String chatUserUid}) async =>
      _userApi.getFriendChatroomNotRead(chatUserUid: chatUserUid);

  Future<AppResponse> getUserSearchResult({required String searchText}) async =>
      _userApi.getUserSearchResult(searchText: searchText);

  Future<AppResponse> addUser(UserModel userModel) async =>
      _userApi.addUser(userModel: userModel);

  Future<AppResponse> addFriend(
          {required String uid,
          required String friendUid,
          required String friendName,
          String friendType = 'default'}) async =>
      _userApi.addFriend(
          uid: uid,
          friendUid: friendUid,
          friendName: friendName,
          friendType: friendType);

  Future<AppResponse> updateFriendLastMessage({
    required String message,
    required String userUid,
    required String chatWithUserUid,
  }) async =>
      _userApi.updateFriendLastMessage(
          message: message, userUid: userUid, chatWithUserUid: chatWithUserUid);

  Future<AppResponse> updateUserInRoom({
    required String friendUid,
    required bool isInRoom,
  }) async =>
      _userApi.updateUserInRoom(friendUid: friendUid, isInRoom: isInRoom);

  @override
  void onInit() {
    logger.i('调用 UserModule');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('结束调用 UserModule');
    super.onClose();
  }
}
