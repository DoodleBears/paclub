import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/pack_module.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/helper/image_helper.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class CreatePackController extends GetxController {
  PackModule _packModule = Get.find<PackModule>();
  final List<String> avatarsUrl = [AppConstants.avatarURL];
  PackModel packModel = PackModel(
    ownerUid: AppConstants.uuid,
    ownerName: AppConstants.userName,
    ownerAvatarURL: AppConstants.avatarURL,
    packName: '',
    editorInfo: {},
    tags: [],
  );

  File? imageFile;

  bool isLoading = false;
  bool isPackInfoOK = false;
  bool isPackNameOK = true;
  bool isTagOK = true;
  String errorText = '';
  String tag = '';

  final TextEditingController tagsTextEditingController =
      TextEditingController();

  Future<void> setPackPhoto() async {
    File? imageFile = await pickImage();
    if (imageFile == null) return;
    this.imageFile = imageFile;
    packModel.photoURL = imageFile.path;
    logger.i('设定 Pack Photo 成功');
    update();
  }

  void removePackPhoto() async {
    logger.d('移除 Pack Photo 成功');
    imageFile = null;
    update();
  }

  void onPackNameChanged(String packName) {
    packModel.packName = packName.trim();
    if (isPackNameOK == false) {
      isPackNameOK = true;
      update();
    }
  }

  void onDescriptionChanged(String description) {
    packModel.description = description.trim();
  }

  void onTagsChanged(String tag) {
    this.tag = tag;
    if (isTagOK == false) {
      isTagOK = true;
      update();
    }
  }

  // NOTE: 添加 Tag
  void addTag() {
    tag = tag.trim();
    if (tag.isNotEmpty) {
      if (packModel.tags.any((element) => element == tag)) {
        if (isTagOK) {
          isTagOK = false;
          errorText = 'Tag already exist';
          update();
        }
      } else if (packModel.tags.length > 9) {
        isTagOK = false;
        errorText = 'At most 10 tags';
        update();
      } else {
        tagsTextEditingController.clear();
        packModel.tags.add(tag);
        update();
      }
    }
  }

  // NOTE: 删除 Tag
  void deleteTag(String tag) {
    packModel.tags.remove(tag);
    update();
  }

  // NOTE: 创建 Pack
  void createPack() async {
    if (isLoading) {
      return;
    }
    if (checkPackInfo()) {
      logger.d('开始创建 Pack');

      isLoading = true;
      update();
      await Future.delayed(const Duration(seconds: 3));
      AppResponse appResponse = await _packModule.setPack(
        packModel: packModel,
        imageFile: imageFile,
      );

      toastTop(appResponse.message);

      isLoading = false;
      update();
    }
  }

  bool checkPackInfo() {
    isPackInfoOK = false;
    if (packModel.packName.isEmpty) {
      if (isPackNameOK) {
        errorText = 'pack name cannot be empty';
        isPackNameOK = false;
        update();
      }
    } else {
      isPackInfoOK = true;
    }
    return isPackInfoOK;
  }

  @override
  void onInit() {
    logger.i('启用 CreatePackController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 CreatePackController');
    super.onClose();
  }
}
