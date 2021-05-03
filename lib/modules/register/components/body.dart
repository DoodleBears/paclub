import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/modules/login/components/login_components.dart';
import 'package:paclub/modules/register/register_controller.dart';
import 'package:paclub/r.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/theme/app_theme.dart';

class Body extends GetView<RegisterController> {
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
          GetBuilder<RegisterController>(
            builder: (controller) {
              return RoundedPasswordField(
                color: controller.isPasswordOK ? primaryLightColor : Colors.red,
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
                color:
                    controller.isRePasswordOK ? primaryLightColor : Colors.red,
                // onchanged 会在 input 内容改变时触发 function 并传 string
                onChanged: controller.onRePasswordChanged,
                // 不显示眼睛（不允许显示密码）
                allowHide: false,
              );
            },
          ),
          SizedBox(height: 20),
          // 登录按钮
          GetBuilder<RegisterController>(
            builder: (controller) {
              return RoundedLoadingButton(
                text: 'SIGN UP',
                // 点击后确认登录
                onPressed: controller.submit,
                // 在点击后触发loading效果，加载结束后再次触发，取消loading
                isLoading: controller.isLoading,
              );
            },
          ),
          SizedBox(height: 12),
          // 跳转到注册界面
          AlreadHaveAnAccoutCheck(
            login: false,
            onTap: () => Get.offAllNamed(Routes.LOGIN),
          ),
        ],
      ),
    );
  }
}
