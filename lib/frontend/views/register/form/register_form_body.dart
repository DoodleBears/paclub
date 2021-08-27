import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/login/components/components.dart';
import 'package:paclub/frontend/views/register/form/register_form_controller.dart';
import 'package:paclub/r.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/utils/logger.dart';

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
            form_1(),
            // 自我介绍
            form_2(),
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

  Obx form_2() {
    return Obx(
      () {
        logger.w('重新渲染 form_2');
        return FadeInScaleContainer(
          width: Get.width * 0.8,
          height: controller.page.value == 2 ? 16 + Get.height * 0.20 : 0.0,
          isShow: controller.page.value == 2,
          child: RoundedInputField(
            textInputType: TextInputType.multiline,
            height: 16 + Get.height * 0.17,
            maxLines: 10,
            maxLength: 400,
            labelText: 'Bio',
            onChanged: controller.onBioChanged,
          ),
        );
      },
    );
  }

  Obx form_1() {
    return Obx(
      () {
        logger.w('重新渲染 form_1');
        return FadeInScaleContainer(
          width: Get.width * 0.8,
          height: controller.page.value != 1 ? 0.0 : 16 + Get.height * 0.07,
          isShow: controller.page.value == 1,
          child: RoundedInputField(
            textInputType: TextInputType.name,
            error: controller.isNameOK.value == false,
            hintText: 'Name',
            icon: Icon(
              Icons.person,
              color: accentColor,
            ),
            onChanged: controller.onNameChanged,
          ),
        );
      },
    );
  }
}
