import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/register/components/body.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 —— RegisterPage');
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.arrow_back,
            size: 28.0,
          ),
          color: accentColor,
          onPressed: () {
            logger.i('返回登录页面');
            Get.back();
          },
        ),
      ),
      body: Body(),
    );
  }
}
