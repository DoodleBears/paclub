import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';

class WritePostController extends GetxController {
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
