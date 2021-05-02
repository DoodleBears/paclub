/*
 * @Author: your name
 * @Date: 2020-12-08 20:57:12
 * @LastEditTime: 2020-12-12 14:37:43
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /todo/lib/routes/app_pages.dart
 */
/*
 * @Author: your name
 * @Date: 2020-12-08 20:57:12
 * @LastEditTime: 2020-12-08 21:23:35
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /todo/lib/routes/app_pages.dart
 */
import 'package:get/get.dart';
import 'package:paclub/modules/login/login_binding.dart';
import 'package:paclub/modules/login/login_page.dart';
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
    ),
    GetPage(
      name: Routes.HOME,
      page: () => Tabs(),
    ),
    // GetPage(
    //   name: Routes.SIGN_UP,
    //   page: () => SignUpPage(),
    //   binding: SiginUpBinding(),
    // ),
  ];
}
