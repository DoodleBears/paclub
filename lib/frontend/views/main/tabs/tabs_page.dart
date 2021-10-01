import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/card/card_page.dart';
import 'package:paclub/frontend/views/main/home/home_page.dart';
import 'package:paclub/frontend/views/main/message/message_page.dart';
import 'package:paclub/frontend/views/main/notification/notification_page.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_controller.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
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
                                    top: -8.0,
                                    right: -8.0,
                                    child: GetBuilder<UserController>(
                                      builder: (_) {
                                        logger.e('重新AllMessageNotRead');
                                        return Visibility(
                                          visible: userController
                                                  .messageNotReadAll !=
                                              0,
                                          child: Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Text(
                                              userController.messageNotReadAll >
                                                      99
                                                  ? ''
                                                  : '${userController.messageNotReadAll}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
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
                                    right: -8.0,
                                    top: -8.0,
                                    child: GetBuilder<UserController>(
                                      builder: (_) {
                                        logger.e('重新AllMessageNotRead');
                                        return Visibility(
                                          visible: userController
                                                  .messageNotReadAll !=
                                              0,
                                          child: Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Text(
                                              userController.messageNotReadAll >
                                                      99
                                                  ? '  '
                                                  : '${userController.messageNotReadAll}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
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
}
