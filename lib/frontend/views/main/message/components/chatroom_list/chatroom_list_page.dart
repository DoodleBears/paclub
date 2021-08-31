import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/r.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_body.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatroomListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 chatRoomsListPage');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,

        ///將logo設置在上appber
        title: Image.asset(
          R.appIcon,
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: ChatroomListBody(),
      floatingActionButton: FloatingActionButton(
        ///搜尋用戶的Button，點擊跳轉到搜尋介面
        backgroundColor: Colors.white,
        child: Icon(Icons.search),
        onPressed: () => Get.to(UserSearchPage()),
      ),
    );
  }
}
