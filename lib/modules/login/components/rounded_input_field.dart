import 'package:flutter/material.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/login/components/text_field_container.dart';

// 圆角输入框，用于 (Email) 的输入
class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: primaryLightColor,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(icon, color: accentColor),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
