import 'package:flutter/material.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/login/components/text_field_container.dart';

// 圆角输入框，用于 (Email) 的输入
// 可以控制显示/隐藏密码

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool hidePassword;
  final bool allowHide;
  final VoidCallback onPressed;
  final Color color;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.hidePassword = true,
    this.onPressed,
    this.allowHide = true,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: color ?? primaryLightColor,
      child: TextField(
        onChanged: onChanged,
        obscureText: hidePassword,
        decoration: InputDecoration(
          hintText: 'Password',
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
                  onPressed: onPressed,
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
