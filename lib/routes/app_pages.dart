import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/functions/transitions.dart';
import 'package:paclub/modules/login/login_binding.dart';
import 'package:paclub/modules/login/login_page.dart';
import 'package:paclub/modules/register/register_binding.dart';
import 'package:paclub/modules/register/register_page.dart';
import 'package:paclub/pages/Tabs.dart';

part './app_routes.dart';

abstract class AppPages {
  // A list of <GetPage> 来表示不同页面的 name、binding 和 route 信息等
  // 之后可以用 GetX 的 name 相关的跳转方式
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
      // transition: Transition.rightToLeft,
      // curve: Curves.easeInOutCubic,
      customTransition: ShiftLeftTransitions(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
      // transition: Transition.rightToLeft,
      // curve: Curves.easeInOutCubic,
      customTransition: ShiftLeftTransitions(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => Tabs(),
      // transition: Transition.downToUp,
      // curve: Curves.easeOutCubic,
    ),
  ];
}
