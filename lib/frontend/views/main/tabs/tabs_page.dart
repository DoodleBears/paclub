import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_controller.dart';
import 'package:paclub/utils/logger.dart';

class Tabs extends GetView<TabsController> {
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
      child: Scaffold(
        // FIXME: 用 controller 来管理 Tabs下面的分页是否会有效能问题？
        body: GetBuilder<TabsController>(builder: (_) {
          return controller.currentPage;
        }), // 从controller 得知当前应该显示哪个page
        bottomNavigationBar: GetBuilder<TabsController>(
          builder: (_) {
            return BottomNavigationBar(
              currentIndex: controller.currentIndex,
              onTap: (int index) {
                controller.setIndex(index);
              },
              showSelectedLabels: true,
              backgroundColor: Colors.white,
              selectedItemColor: accentColor,
              unselectedItemColor: Colors.grey[800],
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.lightbulb), label: '抽卡'),
                BottomNavigationBarItem(icon: Icon(Icons.message), label: '私訊'),
                BottomNavigationBarItem(icon: Icon(Icons.alarm), label: '提醒'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: '個人'),
              ],
            );
          },
        ),
      ),
    );
  }
}
