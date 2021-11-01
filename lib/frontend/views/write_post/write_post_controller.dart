import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/pack_module.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/views/write_post/components/draggable_scrollable_attachable_sheet.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/helper/image_helper.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class WritePostController extends GetxController {
  final PackModule _packModule = Get.find<PackModule>();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingControllerCopy =
      TextEditingController();
  final SheetController bottomSheetController = SheetController();
  final ScrollController tagsScrollController = ScrollController();
  final TextEditingController tagsTextEditingController =
      TextEditingController();
  final FocusNode tagsFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final PostModel postModel = PostModel(
    ownerUid: AppConstants.uuid,
    ownerName: AppConstants.userName,
    ownerAvatarURL: AppConstants.avatarURL,
    title: '',
    editorInfo: {},
    tags: [],
  );
  double imageBlockVerticalPadding = 8.0;
  double imageBlockHeight = 160.0;
  late EdgeInsets imageBlockPadding;
  late double imageHeight;

  List<AssetEntity>? assetEntities;
  List<File> imageFiles = [];
  List<double> imageFilesRatio = [];
  SheetState sheetState = SheetState.close;
  bool isPostOK = false;
  bool isTitleOK = true;
  bool isContentOK = true;
  bool isContentFocused = false;
  bool isTagShow = false;
  bool isTagInputShow = false;
  bool isBottomSheetShow = false;
  bool isLoading = false;
  bool isTagOK = true;
  String tag = '';
  String errorText = '';

  final packStream = <PackModel>[].obs;
  List<PackModel> packList = <PackModel>[];
  Map<String, bool> packCheckedList = {};

  // MARK: 创建 Post 相关 Methods
  void createPost() async {
    logger.d('createPost');
    if (isLoading) {
      return;
    }
    if (checkPackInfo()) {
      isLoading = true;
      update();
      await Future.delayed(const Duration(seconds: 2));
      isLoading = false;
      update();
    }
  }

  void pickImages(BuildContext context) async {
    List<AssetEntity>? tempAssetEntities =
        await pickMultiImage(context: context, selectedAssets: assetEntities);
    if (tempAssetEntities != null) {
      assetEntities = List.from(tempAssetEntities);
      List<File?> tempFiles = [];
      List<double> tempFilesRatio = [];
      for (AssetEntity photo in assetEntities!) {
        // logger.d(photo.relativePath);
        File? file = await photo.file;
        var decodedImage = await decodeImageFromList(file!.readAsBytesSync());
        tempFilesRatio.add(decodedImage.width / decodedImage.height);
        tempFiles.add(file);
      }
      imageFilesRatio = List.from(tempFilesRatio);
      imageFiles = List.from(tempFiles);
      // logger.d('imageFiles.length: ${imageFiles.length}');
      if (imageFiles.length == 1) {
        imageBlockVerticalPadding = Get.width * 0.85 / 20;
        imageBlockHeight = Get.width * 0.85;
      } else {
        imageBlockVerticalPadding = Get.height * 0.2 / 20;
        imageBlockHeight = Get.height * 0.2;
      }
      imageBlockPadding = EdgeInsets.symmetric(
        vertical: imageBlockVerticalPadding,
        horizontal: 8.0,
      );
      imageHeight = imageBlockHeight - imageBlockVerticalPadding * 2.0;
      update();
    }
  }

  void removePostPhoto(int index) {
    // logger.d('移除 Pack Photo 成功');
    imageFiles.removeAt(index);
    imageFilesRatio.removeAt(index);
    assetEntities!.removeAt(index);
    if (imageFiles.length == 1) {
      imageBlockVerticalPadding = Get.width * 0.85 / 20;
      imageBlockHeight = Get.width * 0.85;
    } else {
      imageBlockVerticalPadding = Get.height * 0.2 / 20;
      imageBlockHeight = Get.height * 0.2;
    }
    imageBlockPadding = EdgeInsets.symmetric(
      vertical: imageBlockVerticalPadding,
      horizontal: 8.0,
    );
    imageHeight = imageBlockHeight - imageBlockVerticalPadding * 2.0;

    update();
  }

  // NOTE: 当 title 被编辑的时候触发
  void onTitleChanged(String title) {
    postModel.title = title.trim();
    if (isTitleOK == false) {
      isTitleOK = true;
      update();
    }
  }

  // NOTE: 当 packName 被编辑的时候触发
  void onContentChanged(String content) {
    postModel.content = content.trim();
    textEditingControllerCopy.text = content;
    if (isContentOK == false) {
      isContentOK = true;
      update();
    }
  }

  // NOTE: 当 packName 被编辑的时候触发
  bool checkPackInfo() {
    isPostOK = false;
    if (postModel.title.isEmpty) {
      if (isTitleOK) {
        errorText = 'title cannot be empty';
        logger.d(errorText);
        isTitleOK = false;
        update();
      }
    } else if (postModel.content.isEmpty) {
      if (isContentOK) {
        errorText = 'content cannot be empty';
        isContentOK = false;
        update();
      }
    } else {
      isPostOK = true;
    }
    return isPostOK;
  }

  // MARK: Tag 相关的 Methods
  void scrollToBottom() {
    tagsScrollController.animateTo(
      tagsScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void toggleTag() {
    if (isTagShow) {
      isTagShow = false;
      if (tagsFocusNode.hasPrimaryFocus) {
        tagsFocusNode.unfocus();
        isTagInputShow = false;
      }
      if (contentFocusNode.hasPrimaryFocus) {
        contentFocusNode.unfocus();
        isTagShow = true;
      }
    } else {
      if (contentFocusNode.hasPrimaryFocus) {
        contentFocusNode.unfocus();
      }
      isTagShow = true;
    }

    update();
  }

  void toggleTagInput() {
    isTagInputShow = !isTagInputShow;
    if (isTagInputShow == true) {
      tagsFocusNode.requestFocus();
      scrollToBottom();
    } else {
      if (tagsFocusNode.hasPrimaryFocus) {
        tagsFocusNode.unfocus();
      }
    }
    update();
  }

  // NOTE: 监听 Tag 变化
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
      if (postModel.tags.any((element) => element == tag)) {
        if (isTagOK) {
          isTagOK = false;
          errorText = 'Tag already exist';
          update();
        }
      } else if (postModel.tags.length > 9) {
        isTagOK = false;
        errorText = 'At most 10 tags';
        update();
      } else {
        tagsTextEditingController.clear();
        postModel.tags.add(tag);
        update();
      }
    }
  }

  // NOTE: 删除 Tag
  void deleteTag(String tag) {
    postModel.tags.remove(tag);
    update();
  }

  // MARK: BottomSheet 相关的 Methods
  // NOTE: 控制 bottomSheet 的状态 (当拖拽 BottomSheet 上方的 Handler 的时候，在 DragComplete 时触发)
  void onDragComplete(SheetState bottomSheetState) {
    // print(bottomSheetState);
    this.sheetState = bottomSheetState;
    if (bottomSheetState == SheetState.close) {
      isBottomSheetShow = false;
      update(['bottomSheet']);
    } else {
      isBottomSheetShow = true;
      update(['bottomSheet']);
    }
  }

  // NOTE: 开关 BottomSheet
  void toggleBottomSheet(BuildContext context) {
    hideKeyboard(context);
    if (isBottomSheetShow == false) {
      bottomSheetController.normalOpen();
      isBottomSheetShow = true;
      update(['bottomSheet']);
    } else {
      bottomSheetController.close();
      isBottomSheetShow = false;
      update(['bottomSheet']);
    }
  }

  // NOTE: 当 PackTile 的 Checked 状态改变的时候
  void onPackTileChanged(bool? value, int index) {
    if (value != null) {
      packCheckedList[packList[index].pid] = value;
      update(['bottomSheet']);
    }
  }

  // MARK: 页面跳转
  // NOTE: 前往 CreatePackPage
  void navigateToCreatePackPage() {
    Get.toNamed(Routes.CREATEPACK);
  }

  @override
  void onInit() {
    logger.i('启用 WritePostController');
    imageBlockPadding = EdgeInsets.symmetric(
      vertical: imageBlockVerticalPadding,
      horizontal: 8.0,
    );
    imageHeight = imageBlockHeight - imageBlockVerticalPadding * 2.0;
    contentFocusNode.addListener(listenContentInput);
    tagsFocusNode.addListener(listenTagsInput);
    packStream.listen((list) => listenPackStream(list));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    packStream.bindStream(_packModule.getPackStream(
      uid: AppConstants.uuid,
    ));
  }

  // NOTE: 监听是否聚焦 Content Input
  void listenContentInput() {
    // logger.d(
    //     'contentFocusNode.hasPrimaryFocus: ${contentFocusNode.hasPrimaryFocus}');
    if (contentFocusNode.hasPrimaryFocus) {
      if (isContentFocused == false) {
        isContentFocused = true;
        update();
      }
    } else {
      if (isContentFocused == true) {
        isContentFocused = false;
        update();
      }
    }
  }

  void listenTagsInput() {
    // NOTE: 当 Tags Input Field 失去焦点的时候, 如果 Field 在显示, 则自动关闭
    if (tagsFocusNode.hasFocus == false && isTagInputShow) {
      isTagInputShow = false;
      update();
    }
  }

  int sortPack(PackModel a, PackModel b) {
    return b.lastUpdateAt.compareTo(a.lastUpdateAt);
  }

  void listenPackStream(List<PackModel> list) {
    packList = List.from(list);
    for (PackModel pack in packList) {
      if (packCheckedList[pack.pid] == null) {
        packCheckedList[pack.pid] = false;
      }
    }
    packList.sort(sortPack);
    update(['bottomSheet']);
  }

  @override
  void onClose() {
    contentFocusNode.removeListener(listenContentInput);
    tagsFocusNode.removeListener(listenTagsInput);
    packStream.close();
    logger.w('关闭 WritePostController');
    super.onClose();
  }
}
