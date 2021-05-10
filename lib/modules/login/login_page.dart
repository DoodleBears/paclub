import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/colors.dart';
import 'package:paclub/modules/login/login_controller.dart';
import 'package:paclub/widgets/logger.dart';
import 'components/body.dart';

// login 界面开始于这里，Body中用到的 components组件，在 lib/modules/login/components 内
class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— LoginPage');
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          body: Body(),
          appBar: AppBar(
            shadowColor: Colors.transparent,
            centerTitle: true,
            actions: controller.isNeedToResend == true
                ? [
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: TextButton(
                        onPressed: controller.sendEmailCountDown == 0
                            ? () {
                                controller.resendEmail();
                              }
                            : () {},
                        style: TextButton.styleFrom(
                          shadowColor: Colors.transparent,
                          primary: controller.sendEmailCountDown == 0
                              ? accentColor
                              : Colors.grey[600],
                          backgroundColor: controller.sendEmailCountDown == 0
                              ? Colors.grey[100]
                              : Colors.grey[300],
                        ),
                        child: Text(
                          controller.sendEmailCountDown == 0
                              ? 'resend'
                              : controller.sendEmailCountDown.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]
                : [],
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
      },
    );
  }
}
