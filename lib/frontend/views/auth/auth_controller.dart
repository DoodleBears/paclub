import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/frontend/utils/timer.dart';
import 'package:paclub/frontend/widgets/notifications/notifications.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/utils/app_response.dart';

class AuthController extends GetxController {
  final AuthModule authModule = Get.find();
  late AppTimer countdownTimer = AppTimer();
  int countdown = 0;

  Future<void> sendEmailVerification(int time) async {
    if (countdown != 0) return;

    logger.d('开始发送验证 email');
    countdown = time;
    update();
    AppResponse appResponse = await authModule.sendEmailVerification();
    if (appResponse.data != null) {
      countdownTimer.setCountdownTimer(
          time: countdown,
          function: () {
            countdown--;
            update();
          });
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }
      snackbar(
          title: 'Verify Your Account',
          msg: 'verification email was sent to:\n' + (authModule.user!.email!),
          icon: Icon(Icons.email, color: accentColor, size: Get.width * 0.08));
    } else {
      countdown = 0;
      update();
      toastBottom(appResponse.message);
    }
  }

  bool isEmailVerified() {
    authModule.reload();
    if (authModule.isEmailVerified()) {
      return true;
    } else {
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }
      snackbar(
          title: 'Verify Your Account',
          msg: 'verification email was sent to:\n' + (authModule.user!.email!),
          icon: Icon(Icons.email, color: accentColor, size: Get.width * 0.08));
      return false;
    }
  }

  @override
  void onInit() {
    logger.i('启用 AuthController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 AuthController');
    super.onClose();
  }
}
