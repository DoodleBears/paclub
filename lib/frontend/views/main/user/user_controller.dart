import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/helper/image_helper.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class UserController extends GetxController {
  final UserModule _userModule = Get.find<UserModule>();
  final AuthModule _authModule = Get.find<AuthModule>();
  final TextEditingController displayNameTextController =
      TextEditingController();
  final TextEditingController bioTextController = TextEditingController();
  String uid = '';
  UserModel myUserModel = UserModel(uid: '', displayName: '', email: '');
  UserModel otherUserModel = UserModel(uid: '', displayName: '', email: '');
  late String avatarURLNew;
  late String displayNameNew;
  late String bioNew;
  bool isProfileEdited = false;
  bool isSaveLoading = false;
  File? imageFile;

  Future<void> signOut() async {
    await _authModule.signOut();
  }

  void resetEditPage() {
    imageFile = null;
    isProfileEdited = false;
    displayNameNew = myUserModel.displayName;
    bioNew = myUserModel.bio;
    bioTextController.text = bioNew;
    displayNameTextController.text = displayNameNew;
    avatarURLNew = myUserModel.avatarURL;
  }

  Future<void> updateUserProfile() async {
    if (isSaveLoading || isProfileEdited == false) {
      return;
    }
    Map<String, dynamic> updateData = {};
    if (myUserModel.displayName != displayNameNew) {
      updateData['displayName'] = displayNameNew;
    }
    if (myUserModel.bio != bioNew) {
      updateData['bio'] = bioNew;
    }
    // NOTE: 没有任何更新，返回
    if (updateData.isEmpty && imageFile == null) {
      return;
    }

    // NOTE: 开始更新 Profile Data
    isSaveLoading = true;
    update();

    AppResponse appResponse = await _userModule.updateUserProfile(
      imageFile: imageFile,
      updateMap: updateData,
    );
    if (appResponse.data != null) {
      logger.d('成功 updateMyUserProfile');
      isProfileEdited = false;
      Map<String, dynamic> newProfileData = appResponse.data;
      if (myUserModel.displayName != displayNameNew) {
        myUserModel.displayName = newProfileData['displayName'];
        AppConstants.userName = newProfileData['displayName'];
      }
      if (myUserModel.bio != bioNew) {
        myUserModel.bio = newProfileData['bio'];
        AppConstants.bio = newProfileData['bio'];
      }
      if (imageFile != null) {
        myUserModel.avatarURL = newProfileData['avatarURL'];
        AppConstants.avatarURL = newProfileData['avatarURL'];
      }
    } else {
      toastCenter(appResponse.message);
    }
    isSaveLoading = false;

    update();
  }

  Future<void> setAvatar() async {
    File? imageFile = await pickImage();
    if (imageFile == null) return;
    this.imageFile = imageFile;
    avatarURLNew = imageFile.path;
    checkEdited();
  }

  void onDisplayNameChanged(String displayName) {
    displayNameNew = displayName;
    checkEdited();
  }

  void onBioChanged(String bio) {
    bioNew = bio;
    checkEdited();
  }

  void checkEdited() {
    if (myUserModel.bio != bioNew ||
        myUserModel.avatarURL != avatarURLNew ||
        myUserModel.displayName != displayNameNew) {
      isProfileEdited = true;
    } else {
      isProfileEdited = false;
    }
    update();
  }

  @override
  void onInit() async {
    logger.i('启用 UserController');
    getUserProfile(isMe: true);

    FlutterAppBadger.isAppBadgeSupported();
    super.onInit();
  }

  Future<void> getUserProfile({required bool isMe}) async {
    if (await _getPageParameter(isMe: isMe) == false) {
      return;
    }
    AppResponse appResponse =
        await _userModule.getUserProfile(uid: isMe ? AppConstants.uuid : uid);
    if (appResponse.data != null) {
      UserModel userModel = appResponse.data;
      // NOTE: 如果不是自己，则考虑更新 Friend 的头像 Link 和 displayName, 如果该 user 有更改过信息
      if (isMe == false) {
        Map<String, dynamic> updateMap = {};
        if (otherUserModel.displayName != userModel.displayName) {
          updateMap['friendName'] = userModel.displayName;
          otherUserModel.displayName = userModel.displayName;
        }
        if (otherUserModel.avatarURL != userModel.avatarURL) {
          updateMap['avatarURL'] = userModel.avatarURL;
          otherUserModel.avatarURL = userModel.avatarURL;
        }
        if (updateMap.isNotEmpty) {
          _userModule.updateFriendProfile(friendUid: uid, updateMap: updateMap);
        }
      }

      otherUserModel.bio = userModel.bio;

      if (isMe == true) {
        myUserModel = appResponse.data;
        bioNew = myUserModel.bio;
        AppConstants.bio = myUserModel.bio;
        avatarURLNew = myUserModel.avatarURL;
        AppConstants.avatarURL = myUserModel.avatarURL;
        displayNameNew = myUserModel.displayName;
        AppConstants.userName = myUserModel.displayName;
        bioTextController.text = bioNew;
        displayNameTextController.text = displayNameNew;
      }
      update();
    } else {
      toastCenter(appResponse.message);
    }
  }

  Future<bool> _getPageParameter({required bool isMe}) async {
    // NOTE: 如果是个人页面
    if (isMe) {
      if (myUserModel.avatarURL == '') {
        return true;
      }
      return false;
    }
    // NOTE: 如果是其他人的页面
    if (uid != Get.parameters['uid']) {
      // logger.d('${Get.parameters}\n${Get.arguments}');
      // NOTE: 清空otherUserModel，防止查看不同的User的个人信息的时候，出现残留信息
      otherUserModel = UserModel(uid: '', displayName: '', email: '');
      otherUserModel.avatarURL = Get.arguments['avatarURL']!;
      otherUserModel.displayName = Get.arguments['userName']!;
      uid = Get.parameters['uid']!;
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    logger.w('关闭 UserController');
    super.onClose();
  }
}
