import 'package:get/get.dart';
import 'package:paclub/functions/transitions.dart';
import 'package:paclub/modules/auth/auth_binding.dart';
import 'package:paclub/modules/auth/auth_page.dart';
import 'package:paclub/modules/main/tabs/tabs_binding.dart';
import 'package:paclub/modules/login/login_binding.dart';
import 'package:paclub/modules/login/login_page.dart';
import 'package:paclub/modules/register/account/register_account_binding.dart';
import 'package:paclub/modules/register/account/register_account_page.dart';
import 'package:paclub/modules/register/form/register_form_binding.dart';
import 'package:paclub/modules/register/form/register_form_page.dart';
import 'package:paclub/modules/splash/splash_binding.dart';
import 'package:paclub/modules/splash/splash_page.dart';
import 'package:paclub/modules/main/tabs/tabs_page.dart';

part './app_routes.dart';

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
      customTransition: ShiftLeftTransitions(),
      popGesture: true,
    ),
    GetPage(
      name: Routes.REGISTER_FORM,
      page: () => RegisterFormPage(),
      binding: RegisterFormBinding(),
      customTransition: ShiftLeftTransitions(),
      popGesture: true,
    ),
    GetPage(
      name: Routes.REGISTER_ACCOUNT,
      page: () => RegisterAccountPage(),
      binding: RegisterAccountBinding(),
      customTransition: ShiftLeftTransitions(),
      popGesture: true,
    ),
    GetPage(
      name: Routes.HOME,
      binding: TabsBinding(),
      page: () => Tabs(),
      customTransition: TopLeftMaskBelowLeftTransitions(),
    ),
  ];
}
