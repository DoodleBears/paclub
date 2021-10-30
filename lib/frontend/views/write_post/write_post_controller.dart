import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/modules/pack_module.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/views/write_post/components/draggable_scrollable_attachable_sheet.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/utils/logger.dart';

class WritePostController extends GetxController {
  final PackModule _packModule = Get.find<PackModule>();
  final TextEditingController textEditingController = TextEditingController();
  final SheetController bottomSheetController = SheetController();
  final ScrollController bottomScrollController = ScrollController();
  SheetState sheetState = SheetState.close;
  bool isBottomSheetShow = false;
  bool isLoading = false;

  final packStream = <PackModel>[].obs;
  List<PackModel> packList = <PackModel>[];
  Map<String, bool> packCheckedList = {};

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

  void checkBoxOnChange(bool? value, String pid) {
    if (value != null) {
      packCheckedList[pid] = value;
      update(['packList']);
    }
  }

  @override
  void onInit() {
    bottomScrollController.addListener(listenScroll);
    logger.i('启用 WritePostController');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    packStream.listen((list) => listenPackStream(list));

    packStream.bindStream(_packModule.getPackStream(
      uid: AppConstants.uuid,
    ));
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
    bottomScrollController.removeListener(listenScroll);
    logger.w('关闭 WritePostController');
    super.onClose();
  }
}
