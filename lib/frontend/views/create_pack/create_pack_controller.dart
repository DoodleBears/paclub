import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/pack_module.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/helper/image_helper.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class CreatePackController extends GetxController {
  PackModule _packModule = Get.find<PackModule>();
  final List<String> avatarsUrl = [AppConstants.avatarURL];
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final TextEditingController packNameTextEditingController =
      TextEditingController();
  final TextEditingController tagsTextEditingController =
      TextEditingController();
  final PackModel packModel = PackModel(
    ownerUid: AppConstants.uuid,
    ownerName: AppConstants.userName,
    ownerAvatarURL: AppConstants.avatarURL,
    packName: '',
    editorInfo: {},
    tags: [],
  );

  File? imageFile;

  bool isLoading = false;
  bool isPackOK = false;
  bool isPackNameOK = true;
  bool isTagOK = true;
  String tag = '';
  String errorText = '';
  int process = 0;
  String processInfo = '';

  Future<void> setPackPhoto() async {
    File? imageFile = await pickImage();
    if (imageFile == null) return;
    this.imageFile = imageFile;
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
      process = 0;
      processInfo = 'Creating Pack...';
      update(['progress_bar']);

      logger.d('开始创建 Pack');

      isLoading = true;
      update();
      AppResponse appResponseSetPack = await _packModule.setPack(
        packModel: packModel,
      );

      if (appResponseSetPack.data != null) {
        if (imageFile != null) {
          process = 1;
          processInfo = 'Uploading Image...';
          update(['progress_bar']);
          AppResponse appResponseUploadPackPhoto =
              await _packModule.uploadPackPhoto(
                  imageFile: imageFile!, filePath: appResponseSetPack.data);
          // NOTE: 成功上传 Pack 头图

          if (appResponseUploadPackPhoto.data != null) {
            process = 2;
            update(['progress_bar']);
            AppResponse appResponseUpdatePack = await _packModule.updatePack(
              pid: appResponseSetPack.data,
              updateMap: {
                'photoURL': appResponseUploadPackPhoto.data,
              },
            );

            if (appResponseUpdatePack.data != null) {
              process = 3;
              processInfo = '';
              update(['progress_bar']);
              cleanPackInfo();
            }
          }
        }
      } else {
        processInfo = 'Create Fail';
        process = 3;
        update(['progress_bar']);
      }

      isLoading = false;
      update();
    }
  }

  void cleanPackInfo() {
    tagsTextEditingController.clear();
    packNameTextEditingController.clear();
    descriptionTextEditingController.clear();
    packModel.packName = '';
    packModel.description = '';
    packModel.tags.clear();
    packModel.photoURL = '';
    imageFile = null;
    packModel.editorInfo.clear();
    update();
  }

  bool checkPackInfo() {
    isPackOK = false;
    if (packModel.packName.isEmpty) {
      if (isPackNameOK) {
        errorText = 'pack name cannot be empty';
        isPackNameOK = false;
        update();
      }
    } else {
      isPackOK = true;
    }
    return isPackOK;
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
