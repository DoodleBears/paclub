import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';

class CreatePackController extends GetxController {
  final List<String> avatarsUrl = ['', '', '', '', '', '', '', '', '', ''];
  @override
  void onInit() {
    logger.i('启用 CreatePackController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 CreatePackController');
    super.onClose();
  }
}
