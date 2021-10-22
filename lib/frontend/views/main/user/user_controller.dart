import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/helper/image_helper.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class UserController extends GetxController {
  final UserModule _userModule = Get.find<UserModule>();
  final TextEditingController displayNameTextController =
      TextEditingController();
  final TextEditingController bioTextController = TextEditingController();
  String uid = '';
  UserModel myUserModel = UserModel(uid: '', displayName: '', email: '');
  UserModel otherUserModel = UserModel(uid: '', displayName: '', email: '');
  late String avatarURLNew;
  late String displayNameNew;
  late String bioNew;
  bool isLoadProfile = true;
  bool isProfileEdited = false;
  bool isSaveLoading = false;
  File? imageFile;

  void resetEditPage() {
    imageFile = null;
    isProfileEdited = false;
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
      logger.d('成功 updateUserProfile');
      isProfileEdited = false;
      Map<String, dynamic> newProfileData = appResponse.data;
      if (myUserModel.displayName != displayNameNew) {
        myUserModel.displayName = newProfileData['displayName'];
      }
      if (myUserModel.bio != bioNew) {
        myUserModel.bio = newProfileData['bio'];
      }
      if (imageFile != null) {
        myUserModel.avatarURL = newProfileData['avatarURL'];
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
    FlutterAppBadger.isAppBadgeSupported();
    super.onInit();
  }

  Future<void> getUserProfile({required bool isMe}) async {
    if (isMe && myUserModel.avatarURL != '') {
      return;
    }
    if (await _getPageParameter() == false) {
      return;
    }
    isLoadProfile = true;
    update();
    AppResponse appResponse =
        await _userModule.getUserProfile(uid: isMe ? AppConstants.uuid : uid);
    if (appResponse.data != null) {
      otherUserModel = appResponse.data;

      if (isMe == true) {
        myUserModel = appResponse.data;
        bioNew = myUserModel.bio;
        avatarURLNew = myUserModel.avatarURL;
        displayNameNew = myUserModel.displayName;
        bioTextController.text = bioNew;
        displayNameTextController.text = displayNameNew;
      }
      isLoadProfile = false;
      update();
    } else {
      toastCenter(appResponse.message);
    }
  }

  Future<bool> _getPageParameter() async {
    if (Get.parameters.containsKey('uid')) {
      if (uid != Get.parameters['uid']) {
        uid = Get.parameters['uid'] ?? AppConstants.uuid;
        return true;
      }
      return false;
    } else {
      uid = AppConstants.uuid;
      return true;
    }
  }

  @override
  void onClose() {
    logger.w('关闭 UserController');
    super.onClose();
  }
}
