import 'package:flutter/material.dart';
import 'package:paclub/modules/register/components/body.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 —— RegisterPage');
    return WillPopScope(
      onWillPop: () async {
        logger.i('返回登录页面');
        return true;
      },
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
