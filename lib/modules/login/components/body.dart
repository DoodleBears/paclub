import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/login/components/login_components.dart';
import 'package:paclub/modules/login/components/round_password_field.dart';
import 'package:paclub/modules/login/components/rounded_loading_button.dart';
import 'package:paclub/modules/login/components/rounded_input_field.dart';
import 'package:paclub/modules/login/login_controller.dart';
import 'package:paclub/r.dart';
import 'package:paclub/widgets/logger.dart';
import 'or_divider.dart';

// 登录界面的 View 部分，使用 GetView<LoginController> 直接注入 Controller，
class Body extends GetView<LoginController> {
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
            GetBuilder<LoginController>(
              builder: (controller) {
                return RoundedPasswordField(
                  // onchanged 会在 input 内容改变时触发 function 并传 string
                  onChanged: controller.onPasswordChanged,
                  // 传递 secure value 来控制是否显示密码
                  hidePassword: controller.hidePassword,
                  // 点击效果，点击眼睛(visibility) 切换密码显示和眼睛效果
                  onPressed: controller.changeSecure,
                );
              },
            ),
            const SizedBox(height: 20),
            // 2个按钮
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
              child: GetBuilder<LoginController>(
                builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 登录按钮
                      RoundedLoadingButton(
                        text: 'LOGIN',
                        // 点击后确认登录
                        // 当点击登录后，发送网络请求，用户将无法出发产生界面变化的交互
                        onPressed: controller.isLoading
                            ? () {
                                logger.d('当前处于Loading状态, Button被设置为无效');
                              }
                            : () {
                                logger.d('Login 按钮被按下 —— 提交登录信息，开始进行登录验证');
                                controller.submit(context);
                              },
                        // 在点击后触发loading效果，加载结束后再次触发，取消loading
                        isLoading: controller.isLoading,
                      ),
                      // 重送 resend 按钮
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.linearToEaseOut,
                        height: controller.isButtonShow ? 12 : 0,
                        child: SizedBox.expand(),
                      ),
                      controller.isNeedToResend
                          ? FadeInScaleContainer(
                              isShow: controller.isButtonShow,
                              countdown: controller.sendEmailCountDown,
                              time: 30,
                              controller: controller,
                            )
                          : const SizedBox.shrink(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            const OrDivider(), // OR 的分割线
            const SizedBox(height: 24),
            RoundedButton(
              onPressed: () => controller.signInWithGoogle(),
              imageUrl: R.googleIcon,
              color: white,
            ),
            // 跳过登录，直接进入主页
          ],
        ),
      ),
    );
  }
}
