import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/utils/transitions.dart';
import 'package:paclub/frontend/views/auth/auth_binding.dart';
import 'package:paclub/frontend/views/auth/auth_page.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_binding.dart';
import 'package:paclub/frontend/views/login/login_binding.dart';
import 'package:paclub/frontend/views/login/login_page.dart';
import 'package:paclub/frontend/views/main/user/edit_profile/edit_profile_page.dart';
import 'package:paclub/frontend/views/main/user/profile/profile_page.dart';
import 'package:paclub/frontend/views/register/account/register_account_binding.dart';
import 'package:paclub/frontend/views/register/account/register_account_page.dart';
import 'package:paclub/frontend/views/register/form/register_form_binding.dart';
import 'package:paclub/frontend/views/register/form/register_form_page.dart';
import 'package:paclub/frontend/views/splash/splash_binding.dart';
import 'package:paclub/frontend/views/splash/splash_page.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_page.dart';

part './app_routes.dart';

double Function(BuildContext) gestureWidth(double width) {
  // 当前屏幕宽度减去 给定的 width（一般width设置为比手指的宽度短一些
  // 保证任何大小的屏幕，大拇指都可以从屏幕往右滑动而back
  return (BuildContext context) => context.width - width;
}

abstract class AppPages {
  // A list of <GetPage> 来表示不同页面的 name、binding 和 route 信息等
  // 之后可以用 GetX 的 name 相关的跳转方式
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => AuthPage(),
      binding: AuthBinding(),
      customTransition: FadeInMaskBelowSmallTransitions(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
      customTransition: ShiftLeftLinearTransitions(),
      popGesture: true,
      gestureWidth: gestureWidth(170),
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: Routes.REGISTER_FORM,
      page: () => RegisterFormPage(),
      binding: RegisterFormBinding(),
      customTransition: ShiftLeftLinearTransitions(),
      popGesture: true,
      gestureWidth: gestureWidth(170),
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: Routes.REGISTER_ACCOUNT,
      page: () => RegisterAccountPage(),
      binding: RegisterAccountBinding(),
      customTransition: ShiftLeftLinearTransitions(),
      popGesture: true,
      gestureWidth: gestureWidth(170),
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: Routes.HOME,
      binding: TabsBinding(),
      page: () => Tabs(),
      customTransition: TopLeftMaskBelowLeftLinearTransitions(),
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: Routes.PROFILE,
      // binding: TabsBinding(),
      page: () => ProfilePage(),
      customTransition: TopLeftMaskBelowLeftTransitions(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      // binding: TabsBinding(),
      page: () => EditProfilePage(),
      customTransition: TopLeftMaskBelowLeftLinearTransitions(),
      popGesture: true,
      gestureWidth: gestureWidth(170),
      transitionDuration: const Duration(milliseconds: 250),
    ),
  ];
}
