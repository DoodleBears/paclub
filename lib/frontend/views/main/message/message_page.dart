import 'package:flutter/material.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_page.dart';
import 'package:paclub/utils/logger.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— MessagePage');
    return ChatroomListPage();
  }
}
