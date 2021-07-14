import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';

// 用于 Email, Password 的输入，接受一个 child 作为 input_field
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool error;
  final double height;
  TextFieldContainer({
    Key? key,
    required this.child,
    required this.height,
    this.color = primaryLightColor,
    this.error = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: Get.height * 0.013),
      padding: EdgeInsets.symmetric(horizontal: Get.pixelRatio * 5),
      width: Get.width * 0.8,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: error ? Border.all(width: 2.0, color: Colors.red) : null,
      ),
      child: child,
    );
  }
}
