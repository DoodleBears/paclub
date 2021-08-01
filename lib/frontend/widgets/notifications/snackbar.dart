import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';

/// [文件说明]
/// - 顶部停留的提示框
///
/// [使用场景]
/// - App内需要提示消息的，除去 Toast 的另一种形式
///
/// [传入参数]
/// - [title] 标题
/// - [msg] 消息内容
/// - [icon] 左侧标志
/// - [duration] 在顶部的停留时长
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
