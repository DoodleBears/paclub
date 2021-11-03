import 'package:flutter/material.dart';

class FullWidthTextButton extends StatelessWidget {
  const FullWidthTextButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = Colors.transparent,
    this.height,
    this.alignment,
    required this.overlayColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color overlayColor;
  final Widget child;
  final double? height;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.transparent,
      child: TextButton(
        style: ButtonStyle(
          alignment: alignment,
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          )),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          overlayColor: MaterialStateProperty.all(overlayColor),
          minimumSize: MaterialStateProperty.all(Size.infinite),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
