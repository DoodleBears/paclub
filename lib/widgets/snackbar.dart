import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';

void snackbar({
  required String title,
  required String msg,
  Icon? icon,
  Duration duration = const Duration(seconds: 8),
}) {
  return Get.snackbar(
    title,
    msg,
    showProgressIndicator: true,
    progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(accentColor),
    progressIndicatorBackgroundColor: primaryColor,
    backgroundColor: primaryLightColor.withOpacity(0.4),
    borderRadius: borderRadius,
    padding: EdgeInsets.symmetric(vertical: 14),
    margin: EdgeInsets.symmetric(
        vertical: Get.height * 0.02, horizontal: Get.width * 0.02),
    icon: icon,
    duration: duration,
  );
}
