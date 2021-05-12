import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/login/components/components.dart';
import 'package:paclub/modules/register/account/register_account_controller.dart';
import 'package:paclub/r.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/fade_in_scale_container.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/toast.dart';
import 'package:paclub/widgets/widgets.dart';

class RegisterAccountBody extends GetView<RegisterAccountController> {
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
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return FadeInScaleContainer(
                  width: Get.width * 0.8,
                  height: controller.isRegisterd ? 0.0 : 16 + Get.height * 0.07,
                  isShow: controller.isRegisterd == false,
                  child: RoundedInputField(
                    textInputType: TextInputType.emailAddress,
                    hintText: 'Email',
                    icon: Icons.person,
                    onChanged: controller.onUsernameChanged,
                  ),
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),
            // 密码输入
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return FadeInScaleContainer(
                  width: Get.width * 0.8,
                  height: controller.isRegisterd ? 0.0 : 16 + Get.height * 0.07,
                  isShow: controller.isRegisterd == false,
                  child: RoundedPasswordField(
                    hinttext: 'Password',
                    error: controller.isPasswordOK == false,

                    // onchanged 会在 input 内容改变时触发 function 并传 string
                    onChanged: controller.onPasswordChanged,
                    // 不显示眼睛（不允许显示密码）
                    allowHide: false,
                  ),
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),
            // 重复密码输入
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return FadeInScaleContainer(
                  width: Get.width * 0.8,
                  height: controller.isRegisterd ? 0.0 : 16 + Get.height * 0.07,
                  isShow: controller.isRegisterd == false,
                  child: RoundedPasswordField(
                    hinttext: 'Repassword',
                    error: controller.isRePasswordOK == false,
                    // onchanged 会在 input 内容改变时触发 function 并传 string
                    onChanged: controller.onRePasswordChanged,
                    // 不显示眼睛（不允许显示密码）
                    allowHide: false,
                  ),
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),

            //* 重送 resend 按钮
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  verticalDirection: VerticalDirection.up,
                  children: [
                    AnimatedSizedbox(
                      height: controller.isResendButtonShow
                          ? context.height * 0.02
                          : 0,
                    ),
                    controller.isNeedToResend
                        ? GetBuilder<RegisterAccountController>(
                            builder: (_) {
                              // 用于渐变出现的 Container
                              return FadeInCountdownButton(
                                icon: Icon(Icons.send),
                                isShow: controller.isResendButtonShow,
                                height: Get.height * 0.08,
                                onPressed: controller.countdown == 0
                                    ? () => controller.resendEmail(time: 30)
                                    : () {},
                                text: 'Resend',
                                countdown: controller.countdown,
                                isLoading: controller.countdown == 30,
                                time: 30,
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
            // 注册按钮
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return RoundedLoadingButton(
                  width:
                      controller.isLoading ? Get.width * 0.4 : Get.width * 0.8,
                  text: controller.isRegisterd ? 'Next' : 'Sign Up',
                  // 点击后确认登录
                  onPressed: controller.isLoading
                      ? () => logger.d('当前处于Loading状态, Button被设置为无效')
                      : controller.isRegisterd
                          ? controller.isEmailVerifyed
                              ? () {
                                  logger.d('Go To next');
                                }
                              : () {
                                  controller.checkResendEmail();
                                  if (controller.isEmailVerifyed) {
                                    Get.until((route) => false);
                                    Get.toNamed(Routes.HOME);
                                  } else {
                                    toast('Verify your email first');
                                  }
                                }
                          : () async {
                              logger.d('提交注册信息，开始进行账号注册');
                              await controller.submit(context);
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
