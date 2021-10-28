import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/views/write_post/components/draggable_scrollable_attachable_sheet.dart';
import 'package:paclub/utils/logger.dart';

class WritePostController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final SheetController bottomSheetController = SheetController();
  bool isBottomSheetShow = false;

  // MARK: 控制 bottomSheet 的相关 methods
  void onDragComplete(SheetState bottomSheetState) {
    // print(bottomSheetState);
    if (bottomSheetState == SheetState.close) {
      isBottomSheetShow = false;
      update(['bottomSheet']);
    } else {
      isBottomSheetShow = true;
      update(['bottomSheet']);
    }
  }

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
