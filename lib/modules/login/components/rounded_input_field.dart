import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/functions/length_limit_textfield_formatter.dart';
import 'package:paclub/modules/login/components/text_field_container.dart';

// 圆角输入框，用于 (Email) 的输入
// TODO: 把 height 和 width 改为 required
class RoundedInputField extends StatelessWidget {
  final TextInputType textInputType;
  final ValueChanged<String> onChanged;
  final String? labelText;
  final String? hintText;
  final double? height;
  final Icon? icon;
  final int maxLines;
  final bool error;
  final int maxLength;
  const RoundedInputField({
    Key? key,
    required this.onChanged,
    required this.textInputType,
    this.hintText,
    this.icon,
    this.height,
    this.maxLines = 1,
    this.labelText,
    this.maxLength = 50,
    this.error = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: primaryLightColor,
      error: error,
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
          // TODO: 看看这个 null 这么写对不对
          icon: icon,
          hintText: labelText ?? hintText,
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
