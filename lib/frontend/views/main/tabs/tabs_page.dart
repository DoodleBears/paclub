import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/card/card_page.dart';
import 'package:paclub/frontend/views/main/home/home_page.dart';
import 'package:paclub/frontend/views/main/message/message_page.dart';
import 'package:paclub/frontend/views/main/notification/notification_page.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_controller.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/views/main/user/my_user_page.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/utils/logger.dart';

class Tabs extends GetView<TabsController> {
  final List<Widget> pageList = [
    HomePage(),
    CardPage(),
    MessagePage(),
    NotificationPage(),
    MyUserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    AppController userController = Get.find<AppController>();
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
      child: GetBuilder<AppController>(builder: (_) {
        return Container(
          color: AppColors.bottomNavigationBarBackgroundColor,
          child: SafeArea(
            top: false,
            child: GetBuilder<TabsController>(builder: (_) {
              return Scaffold(
                backgroundColor: AppColors.bottomNavigationBarBackgroundColor,
                body: pageList[
                    controller.currentIndex], // 从controller 得知当前应该显示哪个page
                bottomNavigationBar: Stack(
                  children: [
                    BottomNavigationBar(
                      enableFeedback: false,
                      showUnselectedLabels: false,
                      currentIndex: controller.currentIndex,
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,

                      onTap: (int index) {
                        controller.setIndex(index);
                      },

                      showSelectedLabels: false,
                      selectedItemColor: AppColors.bottomNavigationBarTabColor,
                      type: BottomNavigationBarType.fixed,
                      iconSize: Get.width * 0.07,
                      // unselectedLabelStyle:
                      //     TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      // selectedLabelStyle:
                      //     TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          activeIcon: Icon(Icons.home),
                          label: '首頁',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.bookmarks_outlined,
                            size: 25.5,
                          ),
                          activeIcon: Icon(
                            Icons.bookmarks,
                            size: 25.5,
                          ),
                          label: '抽卡',
                        ),
                        BottomNavigationBarItem(
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(Icons.mail_outline),
                              Positioned(
                                top: -6.0,
                                right: -10.0,
                                child: GetBuilder<AppController>(
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
                              Icon(Icons.mail),
                              Positioned(
                                right: -10.0,
                                top: -6.0,
                                child: GetBuilder<AppController>(
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
              );
            }),
          ),
        );
      }),
    );
  }

  NumberBadge _buildBadge(AppController userController) {
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
