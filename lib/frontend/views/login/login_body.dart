import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/views/auth/auth_email_controller.dart';
import 'package:paclub/frontend/views/login/components/components.dart';
import 'package:paclub/frontend/views/login/login_controller.dart';
import 'package:paclub/frontend/widgets/buttons/buttons.dart';
import 'package:paclub/frontend/widgets/buttons/rounded_button.dart';
import 'package:paclub/r.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'components/or_divider.dart';

const int countdownTime = 60;

// 登录界面的 View 部分，使用 GetView<LoginController> 直接注入 Controller，
class LoginBody extends GetView<LoginController> {
  final AuthEmailController authEmailController = Get.find();
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
              width: Get.height * 0.11,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: Get.height * 0.006),
            Text(
              'Paclub',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: Get.height * 0.03,
              ),
            ),
            SizedBox(height: Get.height * 0.03), // 用户名和邮箱输入
            GetBuilder<LoginController>(
              builder: (_) {
                return RoundedInputField(
                  textInputType: TextInputType.emailAddress,
                  error: controller.isEmailOK == false,
                  hintText: 'Email',
                  icon: Icon(
                    Icons.person,
                    color: accentColor,
                  ),
                  onChanged: controller.onUsernameChanged,
                );
              },
            ),
            // 密码输入
            SizedBox(height: 3 + Get.height * 0.02),
            GetBuilder<LoginController>(
              // builder 调用的 controller 为 _ 是因为该page的controller要使用同一个，否则如果有2个controller，彼此数据不会同步
              // 改变 A 的某个属性时，不能引起 B 改变
              // 这个 controller 是由 LoginBody() 通过 GetView 注入的
              builder: (_) {
                return RoundedPasswordField(
                  error: controller.isPasswordOK == false,
                  hinttext: 'Password',
                  // onchanged 会在 input 内容改变时触发 function 并传 string
                  onChanged: controller.onPasswordChanged,
                  // 传递 secure value 来控制是否显示密码
                  hidePassword: controller.hidePassword,
                  // 点击效果，点击眼睛(visibility) 切换密码显示和眼睛效果
                  iconOnPressed: controller.changeSecure,
                );
              },
            ),
            //* Resend 按钮
            GetBuilder<LoginController>(
              builder: (_) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    //* 动画 Space
                    AnimatedSizedBox(
                      width: Get.width * 0.8,
                      height: controller.isResendButtonShow
                          ? 3 + Get.height * 0.02
                          : 0,
                    ),
                    //* 重送 resend 按钮
                    GetBuilder<AuthEmailController>(
                      builder: (_) {
                        return FadeInCountdownButton(
                          icon: Icon(Icons.send),
                          isShow: controller.isResendButtonShow,
                          height: Get.height * 0.08,
                          onPressed: () => authEmailController
                              .sendEmailVerification(countdownTime),
                          text: 'Resend',
                          countdown: authEmailController.countdown,
                          isLoading:
                              authEmailController.countdown == countdownTime,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 3 + Get.height * 0.02),
            //* Login 登录按钮
            GetBuilder<LoginController>(
              builder: (_) {
                return RoundedLoadingButton(
                  width:
                      controller.isLoading ? Get.width * 0.4 : Get.width * 0.8,
                  // height: Get.pixelRatio * 16,
                  text: 'Login',
                  onPressed: () => controller.signInWithEmail(context),
                  isLoading: controller.isLoading,
                );
              },
            ),
            GetBuilder<LoginController>(
              builder: (_) {
                return AnimatedSizedBox(
                  width: Get.width * 0.8,
                  height:
                      controller.isResendButtonShow ? 3 + Get.height * 0.02 : 0,
                );
              },
            ),
            // *  直接登录 skip auth 按钮
            GetBuilder<LoginController>(
              builder: (_) {
                return FadeInScaleContainer(
                  isShow: controller.isResendButtonShow,
                  height: Get.height * 0.08,
                  width: Get.width * 0.8,
                  child: RoundedButton(
                    onPressed: () {
                      Get.until((route) => false);
                      Get.toNamed(Routes.TABS);
                    },
                    color: primaryColor,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: Get.height * 0.03),
            const OrDivider(), // OR 的分割线
            SizedBox(height: Get.height * 0.02),
            CircleButton(
              height: Get.height * 0.085,
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
