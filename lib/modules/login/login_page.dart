import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/colors.dart';
import 'package:paclub/widgets/logger.dart';
import 'components/body.dart';

// login 界面开始于这里，Body中用到的 components组件，在 lib/modules/login/components 内
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 —— LoginPage');
    return Scaffold(
      body: Body(),
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
          onPressed: () => Get.back(),
        ),
      ),
    );
  }
}
