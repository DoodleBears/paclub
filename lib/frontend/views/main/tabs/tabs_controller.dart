import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';

class TabsController extends GetxController {
  int currentIndex = 0;

  void setIndex(int index) {
    currentIndex = index;
    // logger.i('当前index是：' + currentIndex.toString());
    update();
  }

  @override
  void onInit() {
    currentIndex = 0;

    logger.i('启用 TabsController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 TabsController');
    super.onClose();
  }
}
