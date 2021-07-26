import 'package:flutter/material.dart';
import 'package:paclub/modules/splash/splash_body.dart';
import 'package:paclub/widgets/logger.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— SplashPage');
    return Scaffold(
      body: SplashBody(),
    );
  }
}
