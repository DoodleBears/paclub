import 'package:flutter/material.dart';
import 'package:paclub/frontend/views/main/message/message_body.dart';
import 'package:paclub/utils/logger.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— MessagePage');
    return MessageBody();
  }
}
