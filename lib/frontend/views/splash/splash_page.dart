import 'package:flutter/material.dart';
import 'package:paclub/frontend/views/splash/splash_body.dart';
import 'package:paclub/utils/logger.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— SplashPage');
    return Scaffold(
      body: SplashBody(),
    );
  }
}
