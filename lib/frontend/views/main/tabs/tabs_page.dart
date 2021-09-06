import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/card/card_page.dart';
import 'package:paclub/frontend/views/main/home/home_page.dart';
import 'package:paclub/frontend/views/main/message/message_page.dart';
import 'package:paclub/frontend/views/main/notification/notification_page.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_controller.dart';
import 'package:paclub/frontend/views/main/user/user_page.dart';
import 'package:paclub/utils/logger.dart';

class Tabs extends GetView<TabsController> {
  final List<Widget> pageList = [
    HomePage(),
    CardPage(),
    MessagePage(),
    NotificationPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— Tabs');
    return WillPopScope(
      // * 如果用户不在Home页面时，使用系统返回键会先返回Home，不会直接退出
      onWillPop: () async {
        if (controller.currentIndex == 0) {
          // logger.i('退出App');
          return true;
        } else {
          controller.setIndex(0);
        }
        return false;
      },
      child: ThemeSwitchingArea(
        child: Builder(
          builder: (context) => Scaffold(
            body: GetBuilder<TabsController>(builder: (_) {
              return pageList[controller.currentIndex];
            }), // 从controller 得知当前应该显示哪个page
            bottomNavigationBar: Container(
              color: AppColors.bottomNavigationBarBackground,
              child: Stack(
                children: [
                  Container(
                    height: 72.0,
                    child: GetBuilder<TabsController>(
                      builder: (_) {
                        return BottomNavigationBar(
                          enableFeedback: false,
                          showUnselectedLabels: false,
                          currentIndex: controller.currentIndex,
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                          onTap: (int index) {
                            controller.setIndex(index);
                          },
                          showSelectedLabels: true,
                          selectedItemColor: accentColor,
                          type: BottomNavigationBarType.fixed,
                          iconSize: 28.0,
                          unselectedLabelStyle: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                          selectedLabelStyle: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                          items: [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home_outlined),
                              activeIcon: Icon(Icons.home),
                              label: '首頁',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.lightbulb_outline),
                              activeIcon: Icon(Icons.lightbulb),
                              label: '抽卡',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.message_outlined),
                              activeIcon: Icon(Icons.message),
                              label: '私訊',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.notifications_outlined),
                              activeIcon: Icon(Icons.notifications),
                              label: '提醒',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.person_outline),
                              activeIcon: Icon(Icons.person),
                              label: '個人',
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // 顶部黑色线条
                  Positioned(
                    child: Container(
                      height: 1.5,
                      color: AppColors.messageBoxBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
