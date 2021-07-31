import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paclub/backend/repository/local/user_preferences.dart';

AppBar buildAppBar(BuildContext context) {
  final user = UserPreferences.getUser();
  final isDarkMode = user.isDarkMode;
  final icon = isDarkMode ? CupertinoIcons.sun_max : CupertinoIcons.moon_stars;

  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0, // z-index高度的感觉，影响 AppBar 的阴影
    actions: [
      IconButton(
        icon: Icon(icon),
        onPressed: () {
          final newUser = user.copy(isDarkMode: !isDarkMode);
          UserPreferences.setUser(newUser);
        },
      ),
    ],
  );
}
