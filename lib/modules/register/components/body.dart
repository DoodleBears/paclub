import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/login/components/components.dart';
import 'package:paclub/modules/register/register_controller.dart';
import 'package:paclub/r.dart';
import 'package:paclub/widgets/logger.dart';

class Body extends GetView<RegisterController> {
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
            RoundedInputField(
              hintText: 'Email',
              icon: Icons.person,
              onChanged: controller.onUsernameChanged,
            ),
            SizedBox(height: 3 + Get.height * 0.02),
            // 密码输入
            GetBuilder<RegisterController>(
              builder: (controller) {
                return RoundedPasswordField(
                  hinttext: 'Password',
                  color:
                      controller.isPasswordOK ? primaryLightColor : Colors.red,
                  // onchanged 会在 input 内容改变时触发 function 并传 string
                  onChanged: controller.onPasswordChanged,
                  // 不显示眼睛（不允许显示密码）
                  allowHide: false,
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),
            // 重复密码输入
            GetBuilder<RegisterController>(
              builder: (controller) {
                return RoundedPasswordField(
                  hinttext: 'Repassword',
                  color: controller.isRePasswordOK
                      ? primaryLightColor
                      : Colors.red,
                  // onchanged 会在 input 内容改变时触发 function 并传 string
                  onChanged: controller.onRePasswordChanged,
                  // 不显示眼睛（不允许显示密码）
                  allowHide: false,
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),

            // 注册按钮
            GetBuilder<RegisterController>(
              builder: (controller) {
                return RoundedLoadingButton(
                  // height: 100.0 - Get.height * 0.08,
                  width:
                      controller.isLoading ? Get.width * 0.4 : Get.width * 0.8,
                  text: 'Sign Up',
                  // 点击后确认登录
                  onPressed: controller.isLoading
                      ? () {
                          logger.d('当前处于Loading状态, Button被设置为无效');
                        }
                      : () {
                          logger.d('提交注册信息，开始进行账号注册');
                          controller.submit(context);
                        },
                  // 在点击后触发loading效果，加载结束后再次触发，取消loading
                  isLoading: controller.isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
