import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/register/form/register_form_body.dart';
import 'package:paclub/modules/register/form/register_form_controller.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterFormPage extends GetView<RegisterFormController> {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— RegisterFormPage');
    return WillPopScope(
      onWillPop: () async {
        if (controller.page.value == 1) {
          return true;
        } else {
          controller.prevPage();
        }
        return false;
      },
      child: Scaffold(
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
                onPressed: () => controller.page.value == 1
                    ? Get.back()
                    : controller.prevPage(),
              ),
            ),
          ),
        ),
        body: RegisterFormBody(),
      ),
    );
  }
}
