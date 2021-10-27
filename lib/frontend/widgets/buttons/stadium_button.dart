import 'package:flutter/material.dart';

class StadiumButton extends StatelessWidget {
  const StadiumButton({
    Key? key,
    required this.buttonColor,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
  }) : super(key: key);
  final Color buttonColor;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          color: buttonColor,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
