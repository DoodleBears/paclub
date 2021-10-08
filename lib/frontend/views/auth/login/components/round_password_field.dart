import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/auth/login/components/text_field_container.dart';

// 圆角输入框，用于 (Email) 的输入
// 可以控制显示/隐藏密码

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool hidePassword;
  final bool allowHide;
  final VoidCallback? iconOnPressed;
  final Color color;
  final bool error;
  final String? hinttext;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    this.iconOnPressed,
    this.hidePassword = true,
    this.allowHide = true,
    this.color = primaryLightColor,
    this.error = false,
    this.hinttext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      height: 16 + Get.height * 0.07,
      color: color,
      error: error,
      child: TextField(
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(
          fontSize: Get.height * 0.022,
          color: Colors.black,
        ),
        cursorHeight: Get.height * 0.033,
        onChanged: onChanged,
        obscureText: hidePassword,
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: TextStyle(
            fontSize: Get.height * 0.022,
            color: Colors.black,
          ),
          // 左侧icon
          icon: Icon(Icons.lock, color: accentColor),
          // 右侧icon
          suffixIcon: allowHide
              ? IconButton(
                  // 去除点击效果
                  tooltip: hidePassword ? '显示密码' : '隐藏密码',
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  // 判断 hidePassword 的值来显示不同 icon

                  icon: hidePassword
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  // 点击icon之后会让 Controller 改变 hidePassword 的 value
                  onPressed: iconOnPressed,
                  // enableFeedback: false,
                  color: accentColor,
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
