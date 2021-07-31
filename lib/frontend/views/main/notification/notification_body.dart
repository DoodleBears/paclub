import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/notification/notification_controller.dart';

class NotificationBody extends GetView<NotificationController> {
  const NotificationBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Container(
            child: Center(
              child: Text(
                controller.testString,
                style: TextStyle(fontSize: 24),
              ),
            ),
            color: accentColor,
            height: Get.height * 0.1,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 50,
            // 由外层 SingleChildScrollView 来控制滚动
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, item) {
              return ListTile(
                title: Text('Notification Page Developing...'),
              );
            },
          ),
        ],
      ),
    );
  }
}
