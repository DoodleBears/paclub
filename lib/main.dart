import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/repository/local/user_preference.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/theme/themes.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/routes/app_binding.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/utils/dependency_injection.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/utils/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.edgeToEdge,
  // );

  // 去除 StatusBar 的颜色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // await Firebase.initializeApp();
  // App 开启时就优先启动的各种, 如 Controller, Service(比如用于检测登录, 自动登录的)
  logger.wtf('点击链接查看更多 logger 使用方式 https://pub.dev/packages/logger/example');

  await DenpendencyInjection.init();

  // 注入UserPreference
  await UserPreference.init();
  Get.lazyPut<AppController>(() => AppController());

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final AppController userController = Get.find<AppController>();

  @override
  void initState() {
    // 初始化亮暗模式
    initPlatformState();
    var window = WidgetsBinding.instance!.window;
    Brightness brightness = window.platformBrightness;
    setState(() {
      if (brightness == Brightness.light) {
        AppColors.lightMode();
        userController.isDarkMode = false;
      } else {
        AppColors.darkMode();
        userController.isDarkMode = true;
      }
    });
    userController.update();
    // 监听系统的亮暗模式
    window.onPlatformBrightnessChanged = listenToBrightness;
    super.initState();
  }

  initPlatformState() async {
    if (Platform.isAndroid || Platform.isIOS) {
      String appBadgeSupported;
      try {
        bool res = await FlutterAppBadger.isAppBadgeSupported();
        if (res) {
          appBadgeSupported = 'Supported';
        } else {
          appBadgeSupported = 'Not supported';
        }
      } on PlatformException {
        appBadgeSupported = 'Failed to get badge support.';
      }
      print(appBadgeSupported);
      logger.e(appBadgeSupported);
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      userController.appBadgeSupported = appBadgeSupported;
    }
  }

  void listenToBrightness() {
    // This callback is called every time the brightness changes.
    Brightness brightness = window.platformBrightness;
    logger.wtf('改变亮暗: $brightness');
    setState(() {
      if (brightness == Brightness.light) {
        AppColors.lightMode();
      } else {
        AppColors.darkMode();
      }
    });
    userController.update();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('渲染 App');

    return GetBuilder<AppController>(
      builder: (_) {
        return FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return SomethingWentWrong();
            }
            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return RefreshConfiguration(
                enableBallisticLoad: false,
                child: GetMaterialApp(
                  themeMode: ThemeMode.system,
                  // controller.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  theme: MyThemes.lightTheme,
                  darkTheme: MyThemes.darkTheme,
                  // customTransition: TopLeftMaskBelowleftTransitions(),
                  builder: (context, child) => Scaffold(
                    // Global GestureDetector that will dismiss the keyboard
                    body: GestureDetector(
                      onTap: () => hideKeyboard(context),
                      child: child,
                    ),
                  ),
                  transitionDuration: Duration(milliseconds: 300),
                  debugShowCheckedModeBanner: false,
                  title: '盒群',
                  getPages: AppPages.pages,
                  initialRoute: Routes.SPLASH,
                  initialBinding: AppBinding(),
                  unknownRoute: GetPage(
                    name: Routes.UNKNOWN,
                    page: () => SomethingWentWrong(),
                  ),
                  // home: LoginPage()
                  popGesture: true,
                  enableLog: false,
                ),
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Loading();
          },
        );
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '404',
                        style: TextStyle(fontSize: 64, color: Colors.grey),
                      ),
                      Text(
                        'Couldn\'t find the page',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: SizedBox.expand(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: CircularProgressIndicator(
                  color: accentColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '加载中',
                style: TextStyle(
                  fontSize: 14,
                  color: grey700,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
