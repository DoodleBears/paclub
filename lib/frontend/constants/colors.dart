import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// MARK: AppColors 作为一个 static class 提供整个 App 中变化的颜色
// MARK: 通过执行 lightMode(), darkMode() 等Mode 进行全局颜色调整
// NOTE: 注意: 需要用 GetBuilder<UserController> 包裹随亮暗模式改变的Widget 并用 update() 触发变色
// NOTE: 如需添加 Mode 只需要新建 nameMode() function 然后对应修改颜色即可
// NOTE: 如需针对某 Widget 增加颜色适配请新增变量，并以 pageWidgetAttributeColor 的方式命名变量

class AppColors {
  // NOTE: Avatar
  static Color? chatAvatarBackgroundColor = primaryColor;
  static Color? profileAvatarBackgroundColor = Colors.grey[200];
  static Color? profileAvatarBorderColor = Colors.grey[400];
  // NOTE: Chatroom
  static Color? chatroomTileBackgroundColor = Colors.grey[50];
  static Color? chatroomMessageTimestampColor = Colors.grey;
  static Color? chatroomNotReadButtonColor = Colors.grey[800];
  static Color? chatBackgroundColor = Colors.grey[50];
  static Color? chatroomMyMessageBackgroundColor = accentColor;
  static Color? chatroomOtherMessageBackgroundColor = Colors.grey[200];
  static Color? chatroomAppBarTitleColor = Colors.black;
  static Color? messageSendingTextFieldBackgroundColor = Colors.grey[100];
  static Color? messageSendingContainerBackgroundColor = Colors.white;
  // NOTE: Home
  static Color? homeListViewBackgroundColor = Colors.grey[200];
  // NOTE: Bottom Sheet
  static Color? bottomSheetHandlerColor = Colors.grey[300];
  static Color? bottomSheetBackgoundColor = Colors.white;
  // NOTE: General Widget
  static Color? containerBackground = Colors.white;
  static Color? maskCurtainColor = Colors.black.withAlpha(164);
  static Color? circleButtonBackgoundColor = Colors.white;
  static Color? bottomNavigationBarTabColor = Colors.black;
  static Color? bottomNavigationBarBackgroundColor = Colors.white;
  static Color? refreshIndicatorColor = Colors.white;
  static Color? divideLineColor = Colors.grey[200];
  // NOTE: Text
  static Color? normalTextColor = Colors.black;
  // NOTE: Shadow
  static Color? normalShadowColor = Colors.grey;
  // NOTE: Color
  static Color? normalGrey = Colors.grey[700];

  // MARK: lightMode - 通过调用 lightMode 和 UserController.update() 便可以进行App亮暗模式的调整
  static lightMode() {
    // NOTE: Avatar
    chatAvatarBackgroundColor = primaryColor;
    profileAvatarBackgroundColor = Colors.grey[200];
    profileAvatarBorderColor = Colors.grey[400];
    // NOTE: Chatroom
    chatroomTileBackgroundColor = Colors.grey[50];
    chatroomMessageTimestampColor = Colors.grey;
    chatroomNotReadButtonColor = Colors.grey[800];
    chatBackgroundColor = Colors.grey[50];
    chatroomMyMessageBackgroundColor = accentColor;
    chatroomOtherMessageBackgroundColor = Colors.grey[200];
    chatroomAppBarTitleColor = Colors.black;
    messageSendingTextFieldBackgroundColor = Colors.grey[100];
    messageSendingContainerBackgroundColor = Colors.white;
    // NOTE: Home
    homeListViewBackgroundColor = Colors.grey[200];
    // NOTE: Bottom Sheet
    bottomSheetHandlerColor = Colors.grey[300];
    bottomSheetBackgoundColor = Colors.white;
    // NOTE: General Widget
    containerBackground = Colors.white;
    maskCurtainColor = Colors.black.withAlpha(164);
    circleButtonBackgoundColor = Colors.white;
    bottomNavigationBarTabColor = Colors.black;
    bottomNavigationBarBackgroundColor = Colors.white;
    refreshIndicatorColor = Colors.white;
    divideLineColor = Colors.grey[200];
    // NOTE: Text
    normalTextColor = Colors.black;
    // NOTE: Shadow
    normalShadowColor = Colors.grey;
    // NOTE: Color
    normalGrey = Colors.grey[700];
  }

  static darkMode() {
    // NOTE: Avatar
    chatAvatarBackgroundColor = primaryDarkColor;
    profileAvatarBackgroundColor = Colors.grey[850];
    profileAvatarBorderColor = Colors.grey[800];
    // NOTE: Chatroom
    chatroomTileBackgroundColor = Colors.grey[850];
    chatroomMessageTimestampColor = Colors.grey[700];
    chatroomNotReadButtonColor = Colors.grey[200];
    chatBackgroundColor = Colors.grey[900];
    chatroomMyMessageBackgroundColor = Colors.grey[800];
    chatroomOtherMessageBackgroundColor = Colors.grey[800];
    chatroomAppBarTitleColor = Colors.grey[100];
    messageSendingTextFieldBackgroundColor = Colors.grey[800];
    messageSendingContainerBackgroundColor = Colors.grey[850];
    // NOTE: Home
    homeListViewBackgroundColor = Colors.black;
    // NOTE: Bottom Sheet
    bottomSheetHandlerColor = Colors.grey[700];
    bottomSheetBackgoundColor = Colors.grey[900];
    // NOTE: General Widget
    containerBackground = Colors.grey[850];
    maskCurtainColor = Colors.black.withAlpha(164);
    circleButtonBackgoundColor = Colors.grey[850];
    bottomNavigationBarTabColor = Colors.white;
    bottomNavigationBarBackgroundColor = Colors.black;
    refreshIndicatorColor = Colors.grey[900];
    divideLineColor = Colors.grey[850];
    // NOTE: Text
    normalTextColor = Colors.white;
    // NOTE: Shadow
    normalShadowColor = Colors.white;
    // NOTE: Color
    normalGrey = Colors.grey;
  }
}

// MARK: App 主题色
const accentColor = Color(0xFF96C336);
const accentLightColor = Color(0xFFB3D270);
const accentDarkColor = Color(0xFF75D118);
const primaryColor = Color(0xFFb8966f);
const primaryLightColor = Color(0xFFd9b890);
const primaryDarkColor = Color(0xFF9c835b);
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
