import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/views/write_post/components/draggable_scrollable_attachable_sheet.dart';
import 'package:paclub/utils/logger.dart';

class WritePostController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final SheetController bottomSheetController = SheetController();
  final ScrollController bottomScrollController = ScrollController();
  SheetState sheetState = SheetState.close;
  bool isBottomSheetShow = false;

  // MARK: 控制 bottomSheet 的相关 methods
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

  void listenScroll() {}

  void navigateToCreatePackPage() {
    Get.toNamed(Routes.CREATEPACK);
  }

  @override
  void onInit() {
    bottomScrollController.addListener(listenScroll);
    logger.i('启用 WritePostController');
    super.onInit();
  }

  @override
  void onClose() {
    bottomScrollController.removeListener(listenScroll);
    logger.w('关闭 WritePostController');
    super.onClose();
  }
}
