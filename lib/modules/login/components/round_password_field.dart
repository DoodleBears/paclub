import 'package:flutter/material.dart';
import 'package:paclub/modules/login/components/text_field_container.dart';
import 'package:paclub/theme/app_theme.dart';

// 圆角输入框，用于 (Email) 的输入
// 可以控制显示/隐藏密码

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool hidePassword;
  final VoidCallback onPressed;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.hidePassword,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        obscureText: hidePassword,
        decoration: InputDecoration(
          hintText: 'Password',
          // 左侧icon
          icon: Icon(Icons.lock, color: accentColor),
          // 右侧icon
          suffixIcon: IconButton(
            // 去除点击效果
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            // 判断 hidePassword 的值来显示不同 icon
            icon: hidePassword
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            // 点击icon之后会让 Controller 改变 hidePassword 的 value
            onPressed: onPressed,
            enableFeedback: false,
            color: accentColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
