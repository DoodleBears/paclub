import 'package:get/get.dart';

import 'package:paclub/widgets/logger.dart';

class RegisterFormController extends GetxController {
  // 填写到哪一步了
  RxInt page = 1.obs;
  String name = '';
  String bio = '';
  bool isPrevButtonShow = false;

  void nextPage() {
    page++;
    update();
  }

  void prevPage() {
    if (page.value != 1) {
      page--;
      update();
    }
  }

  @override
  void onInit() {
    logger.i('启用 RegisterFormController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 RegisterFormController');
    super.onClose();
  }

  void onNameChanged(String name) {
    this.name = name.trim();
    update();
  }

  void onBioChanged(String bio) {
    this.bio = bio.trim();
    update();
  }

  bool check() {
    if (name.isEmpty) {
      return false;
    }
    return true;
  }
}
