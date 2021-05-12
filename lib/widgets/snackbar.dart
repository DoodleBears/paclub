import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';

void snackbar(
    {String title,
    String msg,
    Icon icon,
    Duration duration = const Duration(seconds: 8)}) {
  return Get.snackbar(
    title,
    msg,
    showProgressIndicator: true,
    progressIndicatorBackgroundColor: primaryColor,
    borderRadius: borderRadius,
    padding: EdgeInsets.symmetric(vertical: 14),
    backgroundColor: primaryLightColor.withOpacity(0.4),
    margin: EdgeInsets.symmetric(
        vertical: Get.height * 0.02, horizontal: Get.width * 0.02),
    icon: icon,
    duration: duration,
  );
}
