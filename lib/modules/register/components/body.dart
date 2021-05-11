import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/login/components/login_components.dart';
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
            const SizedBox(height: 12),
            Image.asset(
              R.appIcon, //使用Class调用内置图片地址
              width: 100.0,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 6),
            Text(
              'Paclub',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 32),
            // 用户名和邮箱输入
            RoundedInputField(
              hintText: 'Your Email',
              icon: Icons.person,
              onChanged: controller.onUsernameChanged,
            ),
            // 密码输入
            GetBuilder<RegisterController>(
              builder: (controller) {
                return RoundedPasswordField(
                  color:
                      controller.isPasswordOK ? primaryLightColor : Colors.red,
                  // onchanged 会在 input 内容改变时触发 function 并传 string
                  onChanged: controller.onPasswordChanged,
                  // 不显示眼睛（不允许显示密码）
                  allowHide: false,
                );
              },
            ),
            // 重复密码输入
            GetBuilder<RegisterController>(
              builder: (controller) {
                return RoundedPasswordField(
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
            const SizedBox(height: 20),
            // 登录按钮
            GetBuilder<RegisterController>(
              builder: (controller) {
                return RoundedLoadingButton(
                  text: 'SIGN UP',
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
