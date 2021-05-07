import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/logger.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('点击链接查看更多 logger 使用方式 https://pub.dev/packages/logger/example');
    return GetMaterialApp(
      theme: appThemeData,
      // customTransition: TopLeftMaskBelowleftTransitions(),
      builder: (context, child) => Scaffold(
        // Global GestureDetector that will dismiss the keyboard
        body: GestureDetector(
          onTap: () {
            hideKeyboard(context); // 让用户可以点击其他地方取消 focus（聚焦），用来隐藏键盘
          },
          child: child,
        ),
      ),
      // defaultTransition: Transition.native,
      transitionDuration: Duration(milliseconds: 350),
      debugShowCheckedModeBanner: false,
      title: "盒群",
      // initialBinding: LoginBinding(),
      getPages: AppPages.pages,
      initialRoute: Routes.LOGIN,
      // debugShowMaterialGrid: true,
      popGesture: true,
      enableLog: false,
      // home: LoginPage()
    );
  }
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
    logger.d('隐藏键盘 Keyboard');
  }
}
