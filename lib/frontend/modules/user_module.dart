import 'dart:io';

import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_storage_api.dart';
import 'package:paclub/backend/api/user_api.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class UserModule extends GetxController {
  final UserApi _userApi = Get.find<UserApi>();

  // MARK: FirebaseStorageApi
  Future<AppResponse> uploadAvatar({
    required File imageFile,
  }) async {
    final FirebaseStorageApi _firebaseStorageApi =
        Get.find<FirebaseStorageApi>();

    return _firebaseStorageApi.uploadImage(
        imageFile: imageFile, filePath: 'userAvatar/${AppConstants.uuid}');
  }

  // MARK: UserApi
  // MARK: GET 部分
  Future<AppResponse> getUserProfile({required String uid}) async =>
      _userApi.getUserProfile(uid: uid);

  Stream<List<FriendModel>> getFriendChatroomListStream(String uid) =>
      _userApi.getFriendChatroomListStream(uid: uid);

  Future<AppResponse> getFriendChatroomNotRead(
          {required String chatUserUid}) async =>
      _userApi.getFriendChatroomNotRead(chatUserUid: chatUserUid);

  Future<AppResponse> getUserSearchResult({required String searchText}) async =>
      _userApi.getUserSearchResult(searchText: searchText);

  // MARK: ADD 部分
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

  // MARK: UPDATE 部分
  Future<AppResponse> updateFriendProfile({
    required String friendUid,
    required Map<String, dynamic> updateMap,
  }) async =>
      _userApi.updateFriendProfile(friendUid: friendUid, updateMap: updateMap);

  Future<AppResponse> updateUserProfile(
      {File? imageFile, required Map<String, dynamic> updateMap}) async {
    // NOTE: 如果有更新头像图片, 则先连接 Firebase Storage 上传图片
    if (imageFile != null) {
      AppResponse appResponseUpload = await uploadAvatar(imageFile: imageFile);
      if (appResponseUpload.data != null) {
        updateMap['avatarURL'] = appResponseUpload.data;
      } else {
        return appResponseUpload;
      }
    }
    // NOTE: 更新 Profile
    return _userApi.updateUserProfile(
      uid: AppConstants.uuid,
      updateMap: updateMap,
    );
  }

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

  // MARK: 初始化
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
