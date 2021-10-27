import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/write_post/components/choose_pack_bottom_sheet.dart';
import 'package:paclub/utils/logger.dart';

class WritePostController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollDragController = ScrollController();
  bool isBottomSheetShow = false;
  bool isDraging = false;
  BottomSheetState bottomSheetState = BottomSheetState.close;

  void onDragComplete(BottomSheetState bottomSheetState) {
    this.bottomSheetState = bottomSheetState;
    print(bottomSheetState);
    if (bottomSheetState == BottomSheetState.close) {
      toggleBottomSheet();
    }
  }

  void toggleBottomSheet() {
    if (isBottomSheetShow) {
      isBottomSheetShow = false;
      update();
    } else {
      isBottomSheetShow = true;
      update();
    }
  }

  @override
  void onInit() {
    logger.i('启用 WritePostController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 WritePostController');
    super.onClose();
  }
}
