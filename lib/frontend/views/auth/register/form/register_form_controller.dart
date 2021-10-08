import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/widgets/notifications/notifications.dart';
import 'package:paclub/utils/logger.dart';

class RegisterFormController extends GetxController {
  // HINT: Rx 即 Stream 类型的值，设定为 final 防止重复宣告 Stream
  // Stream 中的 value 是可以不断改变的，需要用 .value 去修改
  final RxInt page = 1.obs; // 当前所在页面（初始为第一页）
  final RxBool isNameOK = true.obs; // 名字是否不为空
  String name = '';
  String bio = '';
  bool isPrevButtonShow = false;

  // * 下一页按钮，按下时执行 check(), 判断能否进入下一页
  void nextPage(BuildContext context) {
    if (check()) {
      if (page.value == 1) {
        page.value++;
        hideKeyboard(context);
      } else if (page.value == 2) {
        Get.toNamed(Routes.AUTH + Routes.REGISTER_ACCOUNT);
      }
    }
  }

  void prevPage() {
    if (page.value != 1) {
      page.value--;
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
    page.close();
    isNameOK.close();
    super.onClose();
  }

  void onNameChanged(String name) {
    this.name = name.trim();
    isNameOK.value = true;
  }

  void onBioChanged(String bio) {
    this.bio = bio.trim();
  }

  bool check() {
    if (name.isEmpty) {
      isNameOK.value = false;
      toastBottom('Name cannot be null');
    } else {
      isNameOK.value = true;
    }

    return isNameOK.value;
  }
}
