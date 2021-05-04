import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/functions/transitions.dart';
import 'package:paclub/modules/login/components/round_password_field.dart';
import 'package:paclub/modules/login/components/rounded_loading_button.dart';
import 'package:paclub/modules/login/components/rounded_input_field.dart';
import 'package:paclub/modules/login/login_controller.dart';
import 'package:paclub/modules/login/login_page.dart';
import 'package:paclub/pages/Tabs.dart';
import 'package:paclub/r.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/theme/app_theme.dart';
import 'already_have_an_account_check.dart';
import 'or_divider.dart';

// 登录界面的 View 部分，使用 GetView<LoginController> 直接注入 Controller，
class Body extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            R.appIcon, //使用Class调用内置图片地址
            width: 100.0,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 6),
          Text(
            'Paclub',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height: 40),
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
          SizedBox(height: 20),
          // 登录按钮
          GetBuilder<LoginController>(
            builder: (controller) {
              return RoundedLoadingButton(
                text: 'LOGIN',
                // 点击后确认登录
                onPressed: () => controller.submit(context),
                // 在点击后触发loading效果，加载结束后再次触发，取消loading
                isLoading: controller.isLoading,
              );
            },
          ),
          SizedBox(height: 12),
          // 跳转到注册界面
          AlreadHaveAnAccoutCheck(
            login: true,
            // onTap: () => Navigator.push(context,
            //     ShiftLeftRoute(exitPage: this, enterPage: RegisterPage())),
            // 使用getPage中预设的动画(app_pages.dart)
            onTap: () => Get.toNamed(Routes.REGISTER),
          ),
          SizedBox(height: 24),
          OrDivider(), // OR 的分割线
          SizedBox(height: 24),
          // 跳过登录，直接进入主页
          RoundedLoadingButton(
            text: 'SKIP SIGN',
            // 使用自定义的动画，exit效果和enter效果与预设不同
            onPressed: () => Navigator.pushReplacement(
                context,
                BelowDownTopHoldRoute(
                    exitPage: LoginPage(), enterPage: Tabs())),
            // onPressed: () => Get.offNamed(Routes.HOME),
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
