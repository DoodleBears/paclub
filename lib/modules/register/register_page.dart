import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/register/components/body.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— RegisterPage');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Get.height * 0.07,
        shadowColor: Colors.transparent,
        centerTitle: true,
        leading: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
            child: IconButton(
              iconSize: 52.0,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Icons.arrow_back),
              color: accentColor,
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: Body(),
    );
  }
}
