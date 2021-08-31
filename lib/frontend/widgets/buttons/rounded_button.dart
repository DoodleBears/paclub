import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final OutlinedBorder? shape;
  const RoundedButton({
    Key? key,
    required this.onPressed,
    required this.color,
    required this.child,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
        primary: primaryColor,
        padding: EdgeInsets.symmetric(vertical: Get.pixelRatio * 3),
        // 去除 Button 默认的阴影
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
