import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/modules/login/login_binding.dart';
import 'package:paclub/modules/login/login_page.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:logger/logger.dart';
import 'theme/app_theme.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);
var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d(
        'Click here to checkout more Logger utility https://pub.dev/packages/logger/example');
    return GetMaterialApp(
        theme: appThemeData,
        defaultTransition: Transition.native,
        transitionDuration: Duration(milliseconds: 250),
        debugShowCheckedModeBanner: false,
        title: "Welcome to 盒群",
        initialBinding: LoginBinding(),
        getPages: AppPages.pages,
        home: LoginPage());
  }
}
