import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/constants.dart';

// 圆角输入框，用于 (Email) 的输入
// 可以控制显示/隐藏密码

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool hidePassword;
  final bool allowHide;
  final VoidCallback? iconOnPressed;
  final Color color;
  final bool error;
  final String? errorText;
  final String? hintText;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    this.iconOnPressed,
    this.hidePassword = true,
    this.allowHide = true,
    this.color = primaryLightColor,
    this.error = false,
    this.hintText,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.8,
      child: TextField(
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(
          fontSize: Get.height * 0.028,
        ),
        onChanged: onChanged,
        obscureText: hidePassword,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(
            color: error ? Colors.red : null,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: TextStyle(
            color: error ? Colors.red : null,
          ),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: error ? Colors.red : accentColor,
              width: 2.0,
            ),
          ),

          errorText: error ? errorText : null,
        ),
      ),
    );
  }
}
