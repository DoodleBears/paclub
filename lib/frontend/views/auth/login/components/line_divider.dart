import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineDivider extends StatelessWidget {
  final Widget child;
  final Color? lineColor;
  final double deviderLineHeight;
  final EdgeInsetsGeometry? padding;
  const LineDivider(
      {Key? key,
      required this.child,
      this.deviderLineHeight = 1.0,
      this.padding,
      this.lineColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          _buildDivider(),
          child,
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildDivider() => Expanded(
        child: Padding(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: Get.height * 0.04),
          child: Divider(
            color: lineColor ?? Color(0xFFD9D9D9),
            thickness: deviderLineHeight,
          ),
        ),
      );
}
