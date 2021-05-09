import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:paclub/functions/gesture.dart';
import 'package:paclub/routes/app_binding.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/utils/dependency_injection.dart';
import 'package:paclub/widgets/logger.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // App 开启时就优先启动的各种, 如 Controller, Service(比如用于检测登录, 自动登录的)
  logger0.wtf('点击链接查看更多 logger 使用方式 https://pub.dev/packages/logger/example');

  await DenpendencyInjection.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: appThemeData,
      // customTransition: TopLeftMaskBelowleftTransitions(),
      builder: (context, child) => Scaffold(
        // Global GestureDetector that will dismiss the keyboard
        body: GestureDetector(
          onTap: () => hideKeyboard(context),
          child: child,
        ),
      ),
      transitionDuration: Duration(milliseconds: 350),
      debugShowCheckedModeBanner: false,
      title: '盒群',
      getPages: AppPages.pages,
      initialRoute: Routes.SPLASH,
      initialBinding: AppBinding(),
      // home: LoginPage()
      popGesture: true,
      enableLog: false,
    );
  }
}
