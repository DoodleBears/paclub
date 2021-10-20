import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/utils/logger.dart';

class RegisterFormController extends GetxController {
  // HINT: Rx 即 Stream 类型的值，设定为 final 防止重复宣告 Stream
  // Stream 中的 value 是可以不断改变的，需要用 .value 去修改
  int page = 1; // 当前所在页面（初始为第一页）
  bool isNameOK = true; // 名字是否不为空
  String name = '';
  String bio = '';
  String? errorText;
  bool isPrevButtonShow = false;

  // * 下一页按钮，按下时执行 check(), 判断能否进入下一页
  void nextPage(BuildContext context) {
    if (check()) {
      if (page == 1) {
        page++;
        hideKeyboard(context);
        update(['form_1', 'form_2', 'progress_bar']);
      } else if (page == 2) {
        page++;
        hideKeyboard(context);
        update(['form_2', 'form_3', 'progress_bar']);
      } else if (page == 3) {
        // NOTE: 最后一页，选择完头像之后，便结束了注册表单的填写
        Get.toNamed(Routes.AUTH + Routes.REGISTER_ACCOUNT);
      }
    }
  }

  void prevPage() {
    if (page == 2) {
      page--;
      update(['form_1', 'form_2', 'progress_bar']);
    } else if (page == 3) {
      page--;
      update(['form_2', 'form_3', 'progress_bar']);
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
    isNameOK = true;
    update(['form_1']);
  }

  void onBioChanged(String bio) {
    this.bio = bio.trim();
  }

  bool check() {
    if (name.isEmpty && isNameOK) {
      isNameOK = false;
      errorText = 'Name cannot be empty';
      update(['form_1']);
    } else if (isNameOK == false) {
      isNameOK = true;
      update(['form_1']);
    }

    return isNameOK;
  }
}
