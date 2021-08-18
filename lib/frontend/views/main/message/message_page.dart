import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/message/message_body.dart';
import 'package:paclub/frontend/views/main/message/message_controller.dart';
import 'package:paclub/utils/logger.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— MessagePage');
    Get.put(MessageController());
    return MessageBody();
  }
}
