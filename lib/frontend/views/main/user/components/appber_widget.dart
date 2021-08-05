import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/theme/themes.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';

AppBar buildAppBar(BuildContext context) {
  UserController controller = Get.find();
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0, // z-index高度的感觉，影响 AppBar 的阴影
    actions: [
      ThemeSwitcher(
        builder: (context) => GetBuilder<UserController>(
          builder: (_) {
            return IconButton(
              icon: controller.isDarkMode
                  ? Icon(CupertinoIcons.sun_max)
                  : Icon(CupertinoIcons.moon_stars),
              onPressed: () {
                final theme = controller.isDarkMode
                    ? MyThemes.lightTheme
                    : MyThemes.darkTheme;
                ThemeSwitcher.of(context)!.changeTheme(theme: theme);

                controller.isDarkMode = !controller.isDarkMode;
                controller.setUserPreference();
              },
            );
          },
        ),
      ),
    ],
  );
}
