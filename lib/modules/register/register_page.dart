import 'package:flutter/material.dart';
import 'package:paclub/modules/register/components/body.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— RegisterPage');
    return Scaffold(
      body: Body(),
    );
  }
}
