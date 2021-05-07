import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/modules/login/components/round_password_field.dart';
import 'package:paclub/modules/login/components/rounded_loading_button.dart';
import 'package:paclub/modules/login/components/rounded_input_field.dart';
import 'package:paclub/modules/login/login_controller.dart';
import 'package:paclub/r.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/theme/app_theme.dart';
import 'package:paclub/widgets/logger.dart';
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
          const SizedBox(height: 6),
          Text(
            'Paclub',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 40),
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
          // 登录按钮
          GetBuilder<LoginController>(
            builder: (controller) {
              return RoundedLoadingButton(
                text: 'LOGIN',
                // 点击后确认登录
                // 当点击登录后，发送网络请求，用户将无法出发产生界面变化的交互
                onPressed: controller.isLoading
                    ? () {
                        logger.i('当前处于Loading状态, Button被设置为无效');
                      }
                    : () {
                        logger.i('Login 按钮被按下 —— 提交登录信息，开始进行登录验证');
                        controller.submit(context);
                      },
                // 在点击后触发loading效果，加载结束后再次触发，取消loading
                isLoading: controller.isLoading,
              );
            },
          ),
          const SizedBox(height: 12),
          // 跳转到注册界面
          GetBuilder<LoginController>(
            builder: (controller) {
              return AlreadHaveAnAccoutCheck(
                login: true,
                // onTap: () => Navigator.push(context,
                //     ShiftLeftRoute(exitPage: this, enterPage: RegisterPage())),
                // 当点击登录后，发送网络请求，用户将无法出发产生界面变化的交互
                onTap: controller.isLoading
                    // 使用getPage中预设的动画(app_pages.dart)
                    ? () {
                        logger.i('当前处于Loading状态, Button被设置为无效');
                      }
                    : () {
                        logger.i('前往注册页面');
                        Get.toNamed(Routes.REGISTER);
                      },
                // : () => Navigator.push(
                //     context,
                //     TopLeftMaskBelowleftRoute(
                //         exitPage: LoginPage(), enterPage: RegisterPage())),
              );
            },
          ),

          const SizedBox(height: 24),
          const OrDivider(), // OR 的分割线
          const SizedBox(height: 24),
          // 跳过登录，直接进入主页
          GetBuilder<LoginController>(
            builder: (controller) {
              return RoundedLoadingButton(
                text: 'SKIP SIGN',
                // 使用自定义的动画，exit效果和enter效果与预设不同
                onPressed: controller.isLoading
                    // 当点击登录后，发送网络请求，用户将无法出发产生界面变化的交互
                    ? () {
                        logger.i('当前处于Loading状态, Button被设置为无效');
                      }
                    : () {
                        logger.i('跳过登录，直接跳转到主页');

                        //** 希望被pop掉的页面有动画, 则用下面这2个 */
                        /// 用 `Get.offNamed()` 相当于 `pushReplacementNamed`, 会有 pop 的动画, 因为实际操作是先pop了当前页面, 再push
                        /// 用 `Get.offNamedUntil()`, 相当于 `pushNamedAndRemoveUntil`, 会有 pop 动画, 会 pop 掉n个页面, 在push
                        //** 反之, 不要有动画 */
                        /// `1.当只需要pop掉当前1个页面时` Get.offAndToNamed() 相当于 `popAndPushNamed()`, 只会让enter page执行enter动画, 实际操作是先push了新页面，等Push动画结束之后再Pop原本要pop的旧页面
                        /// `2.当需要pop掉很n个页面时` 先用 Get.until(), 然后用 Get.toNamed() `下面的例子就是`
                        // **Get.until(page, (route) => (route as GetPageRoute).routeName == Routes.HOME) 的话就是 pop 到 Home Page 就停下来(Home不会被Pop)
                        // **这里写作 Get.until((route) => false), 就是全部回传false, 全部 pop 掉
                        Get.until((route) => false);
                        Get.toNamed(Routes.HOME);
                        // Get.offNamedUntil(Routes.HOME, (route) => false);
                      },

                isLoading: false,
              );
            },
          )
        ],
      ),
    );
  }
}
