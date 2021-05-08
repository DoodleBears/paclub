import 'package:flutter/material.dart';
import 'package:paclub/modules/auth/components/body.dart';
import 'package:paclub/widgets/logger.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 —— AuthPage');
    return Scaffold(
      body: Body(),
    );
  }
}
