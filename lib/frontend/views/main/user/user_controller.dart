import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/image_helper.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class UserController extends GetxController {
  final UserModule _userModule = Get.find<UserModule>();
  final TextEditingController displayNameTextController =
      TextEditingController();
  final TextEditingController bioTextController = TextEditingController();
  late UserModel currentUserModel;
  late String avatarURLNew;
  late String displayNameNew;
  late String bioNew;
  bool isProfileEdited = false;
  bool isInitialized = false;
  bool isSaveLoading = false;
  // TODO: 将该 imagePath 来源改为 Link (Firebase Storage)
  File? imageFile;

  // TODO: 更新用户资料同步到 server
  Future<void> updateUserProfile() async {
    if (isSaveLoading || isProfileEdited == false) {
      return;
    }
    Map<String, dynamic> updateData = {};
    if (currentUserModel.displayName != displayNameNew) {
      updateData['displayName'] = displayNameNew;
    }
    if (currentUserModel.bio != bioNew) {
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
      if (currentUserModel.displayName != displayNameNew) {
        currentUserModel.displayName = newProfileData['displayName'];
      }
      if (currentUserModel.bio != bioNew) {
        currentUserModel.bio = newProfileData['bio'];
      }
      if (imageFile != null) {
        currentUserModel.avatarURL = newProfileData['avatarURL'];
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
    if (currentUserModel.bio != bioNew ||
        currentUserModel.avatarURL != avatarURLNew ||
        currentUserModel.displayName != displayNameNew) {
      isProfileEdited = true;
    } else {
      isProfileEdited = false;
    }
    update();
  }

  @override
  void onInit() async {
    // TODO: 从服务器请求用户 Profile Data
    AppResponse appResponse = await _userModule.getUserProfile();
    if (appResponse.data != null) {
      currentUserModel = appResponse.data;
      avatarURLNew = currentUserModel.avatarURL;
      bioNew = currentUserModel.bio;
      bioTextController.text = bioNew;
      displayNameNew = currentUserModel.displayName;
      displayNameTextController.text = displayNameNew;
      isInitialized = true;
    } else {
      toastCenter(appResponse.message);
    }

    logger.i('启用 UserController');
    FlutterAppBadger.isAppBadgeSupported();
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 UserController');
    super.onClose();
  }
}
