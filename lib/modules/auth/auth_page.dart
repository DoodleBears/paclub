import 'package:flutter/material.dart';
import 'package:paclub/modules/auth/components/auth_body.dart';
import 'package:paclub/widgets/logger.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— AuthPage');
    return Scaffold(
      body: AuthBody(),
    );
  }
}
