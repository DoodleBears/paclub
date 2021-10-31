import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/pack_module.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/views/write_post/components/draggable_scrollable_attachable_sheet.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/logger.dart';

class WritePostController extends GetxController {
  final PackModule _packModule = Get.find<PackModule>();
  final TextEditingController textEditingController = TextEditingController();
  final SheetController bottomSheetController = SheetController();
  final ScrollController tagsScrollController = ScrollController();
  final TextEditingController tagsTextEditingController =
      TextEditingController();
  final FocusNode tagsTextFocusNode = FocusNode();
  final PostModel postModel = PostModel(
    ownerUid: AppConstants.uuid,
    ownerName: AppConstants.userName,
    ownerAvatarURL: AppConstants.avatarURL,
    title: '',
    editorInfo: {},
    tags: [],
  );
  SheetState sheetState = SheetState.close;
  bool isPostOK = false;
  bool isPostTitleOK = true;
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
  void onPackNameChanged(String title) {
    postModel.title = title.trim();
    if (isPostTitleOK == false) {
      isPostTitleOK = true;
      update();
    }
  }

  bool checkPackInfo() {
    isPostOK = false;
    if (postModel.title.isEmpty) {
      if (isPostTitleOK) {
        errorText = 'title cannot be empty';
        isPostTitleOK = false;
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

  void toggleTagInput() {
    isTagInputShow = !isTagInputShow;
    if (isTagInputShow == true) {
      tagsTextFocusNode.requestFocus();
      scrollToBottom();
    } else {
      if (tagsTextFocusNode.hasPrimaryFocus) {
        tagsTextFocusNode.unfocus();
      }
    }
    update(['tags']);
  }

  // NOTE: 监听 Tag 变化
  void onTagsChanged(String tag) {
    this.tag = tag;
    if (isTagOK == false) {
      isTagOK = true;
      update(['tags']);
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
          update(['tags']);
        }
      } else if (postModel.tags.length > 9) {
        isTagOK = false;
        errorText = 'At most 10 tags';
        update(['tags']);
      } else {
        tagsTextEditingController.clear();
        postModel.tags.add(tag);
        update(['tags']);
      }
    }
  }

  // NOTE: 删除 Tag
  void deleteTag(String tag) {
    postModel.tags.remove(tag);
    update(['tags']);
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

  // NOTE: 前往 CreatePackPage
  void navigateToCreatePackPage() {
    Get.toNamed(Routes.CREATEPACK);
  }

  // NOTE: CheckBox Checked 状态变化
  void checkBoxOnChange(bool? value, String pid) {
    if (value != null) {
      packCheckedList[pid] = value;
      update(['packList']);
    }
  }

  @override
  void onInit() {
    logger.i('启用 WritePostController');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    tagsTextFocusNode.addListener(listenTagsInput);
    packStream.listen((list) => listenPackStream(list));
    packStream.bindStream(_packModule.getPackStream(
      uid: AppConstants.uuid,
    ));
  }

  void listenTagsInput() {
    // NOTE: 当 Tags Input Field 失去焦点的时候, 如果 Field 在显示, 则自动关闭
    if (tagsTextFocusNode.hasFocus == false && isTagInputShow) {
      isTagInputShow = false;
      update(['tags']);
    }
  }

  int sortPack(PackModel a, PackModel b) {
    return b.lastUpdateAt.compareTo(a.lastUpdateAt);
  }

  void listenPackStream(List<PackModel> list) {
    packList = List.from(list);
    for (var i = 0; i < list.length; i++) {
      if (packCheckedList[list[i].pid] == null) {
        packCheckedList[list[i].pid] = false;
      }
    }
    packList.sort(sortPack);
    update(['packList']);
  }

  @override
  void onClose() {
    tagsTextFocusNode.removeListener(listenTagsInput);
    packStream.close();
    logger.w('关闭 WritePostController');
    super.onClose();
  }
}
