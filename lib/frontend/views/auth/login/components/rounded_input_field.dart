import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/utils/length_limit_textfield_formatter.dart';

class RoundedInputField extends StatelessWidget {
  final TextInputType textInputType;
  final ValueChanged<String> onChanged;
  final String? labelText;
  final String? hintText;
  final double? height;
  final Icon? icon;
  final int maxLines;
  final bool error;
  final String? errorText;
  final TextEditingController? controller;
  final String? counterText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final int maxLength;

  /// [圆角输入框，用于 (Email) 的输入]
  /// - [textInputType] 输入的内容类型如: (email, password)
  /// - [onChanged] 绑定input内容的function
  /// - [labelText] 框外左上的提示信息
  /// - [hintText] 框内左上角的提示信息
  /// - [height] 高度
  /// - [icon] 框内左上角，提示信息左侧的图标
  /// - [maxLines] 最大行数
  /// - [error] 内容是否合法，传入false会使输入框描边变红
  /// - [maxLength] 输入内容的最大字符数
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
    this.errorText,
    this.counterText,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.8,
      child: TextField(
        controller: controller,
        inputFormatters: [
          LengthLimitingTextFieldFormatterFixed(maxLength),
        ],
        keyboardType: textInputType,
        style: TextStyle(
          fontSize: Get.height * 0.028,
        ),
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(
          // counterText: counterText,
          labelText: labelText ?? hintText,
          labelStyle: TextStyle(
            color: error ? Colors.red : null,
          ),
          floatingLabelBehavior: floatingLabelBehavior,
          floatingLabelStyle: TextStyle(
            color: error ? Colors.red : null,
          ),
          hintMaxLines: 20,
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
