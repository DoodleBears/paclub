import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/card/card_page.dart';
import 'package:paclub/frontend/views/main/home/home_page.dart';
import 'package:paclub/frontend/views/main/message/message_page.dart';
import 'package:paclub/frontend/views/main/notification/notification_page.dart';
import 'package:paclub/frontend/views/main/user/user_page.dart';
import 'package:paclub/utils/logger.dart';

class TabsController extends GetxController {
  final List<Widget> pageList = [
    HomePage(),
    CardPage(),
    MessagePage(),
    NotificationPage(),
    UserPage(),
  ];
  int currentIndex = 0;
  Widget currentPage = HomePage();

  void setIndex(int index) {
    currentIndex = index;
    // logger.i('当前index是：' + currentIndex.toString());
    currentPage = pageList[index];
    update();
  }

  @override
  void onInit() {
    currentIndex = 0;

    logger.i('启用 TabsController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 TabsController');
    super.onClose();
  }
}
