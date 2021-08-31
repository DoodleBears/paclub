import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/helper/constants.dart';
import 'package:paclub/r.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatroomListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 chatRoomsListPage');
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: primaryColor,

        ///將logo設置在上appber

        title: Row(
          children: [
            Image.asset(
              R.appIcon,
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(Constants.myName),
            ),
          ],
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: ChatroomListBody(),
      floatingActionButton: FloatingActionButton(
        ///搜尋用戶的Button，點擊跳轉到搜尋介面
        backgroundColor: accentColor,
        child: Icon(Icons.search),
        onPressed: () => Get.toNamed(Routes.TABS +
            Routes.MESSAGE +
            Routes.CHATROOMLIST +
            Routes.USERSEARCH),
      ),
    );
  }
}
