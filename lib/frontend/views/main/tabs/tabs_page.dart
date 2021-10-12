import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/card/card_page.dart';
import 'package:paclub/frontend/views/main/home/home_page.dart';
import 'package:paclub/frontend/views/main/message/message_page.dart';
import 'package:paclub/frontend/views/main/notification/notification_page.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_controller.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/frontend/views/main/user/user_page.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
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
    UserController userController = Get.find<UserController>();
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
      child: GetBuilder<UserController>(builder: (_) {
        return GetBuilder<TabsController>(builder: (_) {
          return Scaffold(
            backgroundColor: AppColors.bottomNavigationBarBackgroundColor,
            body:
                pageList[controller.currentIndex], // 从controller 得知当前应该显示哪个page
            bottomNavigationBar: Container(
              color: AppColors.bottomNavigationBarBackgroundColor,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
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
                          iconSize: Get.width * 0.07,
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
                              icon: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(Icons.message_outlined),
                                  Positioned(
                                    top: -6.0,
                                    right: -10.0,
                                    child: GetBuilder<UserController>(
                                      builder: (_) {
                                        return _buildBadge(userController);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              activeIcon: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(Icons.message),
                                  Positioned(
                                    right: -10.0,
                                    top: -6.0,
                                    child: GetBuilder<UserController>(
                                      builder: (_) {
                                        return _buildBadge(userController);
                                      },
                                    ),
                                  )
                                ],
                              ),
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
                      color: AppColors.divideLineColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  NumberBadge _buildBadge(UserController userController) {
    return NumberBadge(
      number: userController.messageNotReadAll,
      maxNumber: 99,
      padding: EdgeInsets.only(
        // bottom: 0.5,
        left: 6.0,
        right: 6.0,
      ),
      textStyle: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      border: BorderSide(
        color: Colors.white,
        width: 1.5,
      ),
    );
  }
}
