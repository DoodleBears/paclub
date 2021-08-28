import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/login/components/components.dart';
import 'package:paclub/frontend/views/register/form/components/register_form_1.dart';
import 'package:paclub/frontend/views/register/form/components/register_form_2.dart';
import 'package:paclub/frontend/views/register/form/register_form_controller.dart';
import 'package:paclub/r.dart';

class RegisterFormBody extends GetView<RegisterFormController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.01,
            ),
            Image.asset(
              R.appIcon, //使用Class调用内置图片地址
              width: Get.width * 0.22,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: Get.height * 0.006),
            Text(
              'Paclub',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: Get.width * 0.06,
              ),
            ),
            SizedBox(height: Get.height * 0.03),
            // 用户名和邮箱输入
            RegisterForm1(),
            // 自我介绍
            RegisterForm2(),
            SizedBox(height: 3 + Get.height * 0.02),
            // 下一页按钮
            Obx(
              () => RoundedLoadingButton(
                width: Get.width * 0.8,
                text: '${controller.page.value}/2 Next',
                // 点击后确认用户名不为空
                onPressed: () => controller.nextPage(context),
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
