import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/colors.dart';
import 'package:paclub/modules/login/login_controller.dart';
import 'package:paclub/widgets/logger.dart';
import 'components/login_body.dart';

// login 界面开始于这里，Body中用到的 components组件，在 lib/modules/login/components 内
class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— LoginPage');
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          body: LoginBody(),
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
        );
      },
    );
  }
}
