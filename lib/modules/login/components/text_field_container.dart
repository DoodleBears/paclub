import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/theme/app_theme.dart';

// 用于 Email, Password 的输入，接受一个 child 作为 input_field
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: context.width * 0.8,
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
