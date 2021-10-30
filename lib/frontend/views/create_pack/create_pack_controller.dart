import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';

class CreatePackController extends GetxController {
  final List<String> avatarsUrl = ['', '', '', '', '', '', '', '', '', ''];
  String packName = '';
  bool isLoading = false;
  bool isPackInfoOK = false;
  bool isPackNameOK = true;
  bool isTagOK = true;
  String errorText = '';
  String description = '';
  List<String> tags = [];

  // final TextEditingController packNameTextEditingController =
  //     TextEditingController();
  // final TextEditingController descriptionTextEditingController =
  //     TextEditingController();
  final TextEditingController tagsTextEditingController =
      TextEditingController();

  void onPackNameChanged(String packName) {
    this.packName = packName.trim();
    if (isPackNameOK == false) {
      isPackNameOK = true;
      update();
    }
  }

  void onDescriptionChanged(String description) {
    this.description = description.trim();
  }

  void onTagsChanged(String packName) {
    this.packName = packName;
    logger.d(packName);
    if (isTagOK == false) {
      isTagOK = true;
      update();
    }
  }

  // NOTE: 添加 Tag
  void addTag() {
    packName = packName.trim();
    if (packName.isNotEmpty) {
      if (tags.any((element) => element == packName)) {
        if (isTagOK) {
          isTagOK = false;
          errorText = 'Tag already exist';
          update();
        }
      } else {
        tagsTextEditingController.clear();
        tags.add(packName);
        update();
      }
    }
  }

  // NOTE: 删除 Tag
  void deleteTag(String tag) {
    tags.remove(tag);
    update();
  }

  // NOTE: 创建 Pack
  void createPack() {
    if (checkPackInfo()) {
      isLoading = true;
      update();
      // TODO: 创建 Pack
    }
  }

  bool checkPackInfo() {
    isPackInfoOK = false;
    if (packName.isEmpty) {
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
