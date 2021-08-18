import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/notification/notification_body.dart';
import 'package:paclub/frontend/views/main/notification/notification_controller.dart';
import 'package:paclub/utils/logger.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— NotificationPage');
    Get.put(NotificationController());
    return NotificationBody();
  }
}
