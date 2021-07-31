import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';

class MessageController extends GetxController {
  String testString = '这是从controller获得的string';

  @override
  void onInit() {
    logger.i('启用 MessageController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 MessageController');
    super.onClose();
  }
}
