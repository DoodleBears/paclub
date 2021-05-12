import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/functions/length_limit_textfield_formatter.dart';
import 'package:paclub/modules/login/components/text_field_container.dart';

// 圆角输入框，用于 (Email) 的输入
class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final double height;
  final IconData icon;
  final TextInputType textInputType;
  final int maxLines;
  final int maxLength;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    @required this.onChanged,
    this.height,
    this.maxLines = 1,
    this.labelText,
    this.maxLength = 50,
    @required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: primaryLightColor,
      height: height ?? 16 + Get.height * 0.07,
      child: TextField(
        inputFormatters: [
          LengthLimitingTextFieldFormatterFixed(maxLength),
        ],
        keyboardType: textInputType,
        style: TextStyle(fontSize: Get.height * 0.022),
        cursorHeight: Get.height * 0.033,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(
          icon: icon == null ? null : Icon(icon, color: accentColor),
          hintText: labelText == null ? hintText : null,
          hintMaxLines: 20,
          labelText: labelText,
          labelStyle: TextStyle(color: accentColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: TextStyle(fontSize: Get.height * 0.022),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
