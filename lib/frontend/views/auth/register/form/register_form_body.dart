import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/auth/login/components/components.dart';
import 'package:paclub/frontend/views/auth/register/form/components/register_form_1.dart';
import 'package:paclub/frontend/views/auth/register/form/components/register_form_2.dart';
import 'package:paclub/frontend/views/auth/register/form/register_form_controller.dart';
import 'package:paclub/frontend/widgets/widgets.dart';

class RegisterFormBody extends GetView<RegisterFormController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              SizedBox(
                height: Get.height * 0.08,
              ),
              // 用户名和邮箱输入
              RegisterForm1(),
              // 自我介绍
              RegisterForm2(),
              SizedBox(height: 3 + Get.height * 0.02),
              // 下一页按钮
              RoundedLoadingButton(
                width: Get.width * 0.8,
                height: Get.height * 0.08,
                text: 'Next',
                // 点击后确认用户名不为空
                onPressed: () => controller.nextPage(context),
                isLoading: false,
              ),
            ],
          ),
          GetBuilder<RegisterFormController>(
            assignId: true,
            id: 'progress_bar',
            builder: (_) {
              return Align(
                alignment: Alignment.topLeft,
                child: FadeInScaleContainer(
                  isShow: true,
                  color: accentColor,
                  height: 4.0,
                  width: Get.width * (controller.page / 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
