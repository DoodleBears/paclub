import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/login/components/components.dart';
import 'package:paclub/modules/login/login_controller.dart';
import 'package:paclub/r.dart';
import 'package:paclub/widgets/fade_in_countdown_button.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/widgets.dart';
import 'components/or_divider.dart';

// 登录界面的 View 部分，使用 GetView<LoginController> 直接注入 Controller，
class LoginBody extends GetView<LoginController> {
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
                    FadeInCountdownButton(
                      icon: Icon(Icons.send),
                      isShow: controller.isResendButtonShow,
                      height: Get.height * 0.08,
                      onPressed: controller.countdown == 0
                          ? () => controller.resendEmail(time: 60)
                          : () {},
                      text: 'Resend',
                      countdown: controller.countdown,
                      isLoading: controller.countdown == 60,
                      time: 60,
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
                  // 当点击登录后, 发送网络请求, 用户将无法出发产生界面变化的交互
                  onPressed: controller.isLoading
                      ? () => logger.d('当前处于Loading状态, Button被设置为无效')
                      : () {
                          logger.d('Login 按钮被按下 —— 提交登录信息，开始进行登录验证');
                          controller.loginSubmit(context);
                        },
                  // 在点击后触发loading效果，加载结束后再次触发，取消loading
                  isLoading: controller.isLoading,
                );
              },
            ),
            SizedBox(height: Get.height * 0.03),
            const OrDivider(), // OR 的分割线
            SizedBox(height: Get.height * 0.02),
            RoundedButton(
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
