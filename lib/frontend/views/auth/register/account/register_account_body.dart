import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/frontend/views/auth/login/components/components.dart';
import 'package:paclub/frontend/views/auth/register/account/register_account_controller.dart';
import 'package:paclub/frontend/widgets/buttons/buttons.dart';
import 'package:paclub/frontend/widgets/buttons/rounded_button.dart';
import 'package:paclub/r.dart';
import 'package:paclub/frontend/widgets/widgets.dart';

const int countdownTime = 60;

class RegisterAccountBody extends GetView<RegisterAccountController> {
  final AuthEmailController authController = Get.find();
  final double inputFieldHeight = Get.height * 0.1;
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
                  height: controller.isRegisterd ? 0.0 : inputFieldHeight,
                  isShow: controller.isRegisterd == false,
                  child: RoundedInputField(
                    textInputType: TextInputType.emailAddress,
                    error: controller.isEmailOK == false,
                    errorText: controller.errorText,
                    labelText: 'Email',
                    onChanged: controller.onUsernameChanged,
                  ),
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),
            // *  密码输入
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return FadeInScaleContainer(
                  width: Get.width * 0.8,
                  height: controller.isRegisterd ? 0.0 : inputFieldHeight,
                  isShow: controller.isRegisterd == false,
                  child: RoundedPasswordField(
                    hintText: 'Password',
                    error: controller.isPasswordOK == false,
                    errorText: controller.errorText,

                    // onchanged 会在 input 内容改变时触发 function 并传 string
                    onChanged: controller.onPasswordChanged,
                    // 不显示眼睛（不允许显示密码）
                    allowHide: false,
                  ),
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),
            // *  重复密码输入
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return FadeInScaleContainer(
                  width: Get.width * 0.8,
                  height: controller.isRegisterd ? 0.0 : inputFieldHeight,
                  isShow: controller.isRegisterd == false,
                  child: RoundedPasswordField(
                    hintText: 'Repassword',
                    error: controller.isRePasswordOK == false,
                    errorText: controller.errorText,
                    // onchanged 会在 input 内容改变时触发 function 并传 string
                    onChanged: controller.onRePasswordChanged,
                    // 不显示眼睛（不允许显示密码）
                    allowHide: false,
                  ),
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),
            // *  注册按钮
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return RoundedLoadingButton(
                  width:
                      controller.isLoading ? Get.width * 0.4 : Get.width * 0.8,
                  height: Get.height * 0.08,
                  text: controller.isRegisterd ? 'Login' : 'Sign Up',
                  color: primaryColor,
                  // 点击后确认登录
                  onPressed: controller.isRegisterd
                      ? () async => controller.loginAfterSignUp()
                      : () async => await controller.registerWithEmail(context),
                  // 在点击后触发loading效果，加载结束后再次触发，取消loading
                  isLoading: controller.isLoading,
                );
              },
            ),
            GetBuilder<RegisterAccountController>(
              builder: (_) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSizedBox(
                      width: Get.width * 0.8,
                      height: controller.isResendButtonShow
                          ? 3 + Get.height * 0.02
                          : 0,
                    ),
                    // *  重送 resend 按钮
                    GetBuilder<AuthEmailController>(
                      builder: (_) {
                        return FadeInCountdownButton(
                          buttonColor: accentColor,
                          textColor: Colors.white,
                          icon: Icon(Icons.send),
                          isShow: controller.isResendButtonShow,
                          height: Get.height * 0.08,
                          // onPressed 仅仅在倒计时为 0 的时候能重送 email, 否则无功能
                          // 按下按钮后触发countdown更新，按钮无效化后进行网络请求
                          onPressed: () => authController
                              .sendEmailVerification(countdownTime),
                          text: 'Resend',
                          countdown: authController.countdown,
                          // isLoading 的值一般和 倒计时设定的值一致，主要用于在联网请求的时候
                          // 有 loading 动画，只有请求成功之后才开始倒计时
                          isLoading: authController.countdown == countdownTime,
                        );
                      },
                    ),
                    AnimatedSizedBox(
                      width: Get.width * 0.8,
                      height: controller.isResendButtonShow
                          ? 3 + Get.height * 0.02
                          : 0,
                    ),
                    // *  直接登录 skip auth 按钮
                    GetBuilder<AuthEmailController>(
                      builder: (_) {
                        return FadeInScaleContainer(
                          isShow: controller.isResendButtonShow,
                          height: Get.height * 0.08,
                          width: Get.width * 0.8,
                          child: RoundedButton(
                            onPressed: () =>
                                controller.loginSkipAuthorization(),
                            color: Colors.grey,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
