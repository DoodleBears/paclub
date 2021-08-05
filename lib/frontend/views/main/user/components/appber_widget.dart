import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';

AppBar buildAppBar(BuildContext context) {
  UserController controller = Get.find();
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0, // z-index高度的感觉，影响 AppBar 的阴影
    actions: [
      GetBuilder<UserController>(
        builder: (_) {
          return IconButton(
            icon: controller.isDarkMode
                ? Icon(CupertinoIcons.sun_max)
                : Icon(CupertinoIcons.moon_stars),
            onPressed: () {
              controller.isDarkMode = !controller.isDarkMode;
              controller.setUserPreference();
            },
          );
        },
      ),
    ],
  );
}
