import 'package:get/get.dart';
import 'package:paclub/widgets/logger.dart';

class NotificationController extends GetxController {
  String testString = '这是从controller获得的string';

  @override
  void onInit() {
    logger.i('启用 NotificationController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 NotificationController');
    super.onClose();
  }
}
