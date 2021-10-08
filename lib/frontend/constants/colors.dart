import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// App主题，包含: 颜色，字体大小等
//  TOOD
class AppColors {
  static Color? chatroomTileBackgroundColor = Colors.grey[50];
  static Color? chatTimestampColor = Colors.grey;
  static Color? notReadButtonColor = Colors.grey[800];
  static Color? refreshIndicatorColor = Colors.white;
  static Color? chatBackgroundColor = Colors.grey[50];
  static Color? chatMeBackgroundColor = accentColor;
  static Color? chatOtherBackgroundColor = Colors.grey[200];
  static Color? chatroomAppBarTitleColor = Colors.black;
  static Color? listViewBackgroundColor = Colors.grey[200];
  static Color? bottomNavigationBarBackgroundColor = Colors.white;
  static Color? divideLineColor = Colors.grey[200];
  static Color? messageBoxBackgroundColor = Colors.grey[100];
  static Color? messageBoxContainerBackgroundColor = Colors.white;

  static lightMode() {
    chatroomTileBackgroundColor = Colors.grey[50];
    chatTimestampColor = Colors.grey;
    notReadButtonColor = Colors.grey[800];
    refreshIndicatorColor = Colors.white;
    chatBackgroundColor = Colors.grey[50];
    chatMeBackgroundColor = accentColor;
    chatOtherBackgroundColor = Colors.grey[200];
    chatroomAppBarTitleColor = Colors.black;
    listViewBackgroundColor = Colors.grey[200];
    bottomNavigationBarBackgroundColor = Colors.white;
    divideLineColor = Colors.grey[200];
    messageBoxBackgroundColor = Colors.grey[100];
    messageBoxContainerBackgroundColor = Colors.white;
  }

  static darkMode() {
    chatroomTileBackgroundColor = Colors.grey[850];
    chatTimestampColor = Colors.grey[700];
    notReadButtonColor = Colors.grey[200];
    refreshIndicatorColor = Colors.grey[900];
    chatBackgroundColor = Colors.grey[900];
    chatMeBackgroundColor = Colors.grey[800];
    chatOtherBackgroundColor = Colors.grey[800];
    chatroomAppBarTitleColor = Colors.grey[100];
    listViewBackgroundColor = Colors.black;
    bottomNavigationBarBackgroundColor = Colors.black;
    divideLineColor = Colors.grey[850];
    messageBoxBackgroundColor = Colors.grey[800];
    messageBoxContainerBackgroundColor = Colors.grey[850];
  }
}

const accentColor = Color(0xFF96C336);
const accentLightColor = Color(0xFFB3D270);
const accentDarkColor = Color(0xFF75D118);
const primaryColor = Color(0xFFF0BF84);
const primaryLightColor = Color(0xFFFCF4E9);
const primaryDarkColor = Color(0xFF9F7C53);
const black = Colors.black;
const grey100 = Color(0xFFF5F5F5);
const grey700 = Color(0xFF333333);

const white = Colors.white;

// const primaryTextColor = Color(0xFFF1E6FF);
// const secondaryTextColor = Color(0xFFF1E6FF);

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
