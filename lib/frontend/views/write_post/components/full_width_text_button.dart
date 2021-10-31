import 'package:flutter/material.dart';

class FullWidthTextButton extends StatelessWidget {
  const FullWidthTextButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    this.height,
    this.alignment,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Widget child;
  final double? height;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextButton(
        style: ButtonStyle(
          alignment: alignment,
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          )),
          backgroundColor:
              MaterialStateProperty.all(backgroundColor.withAlpha(48)),
          overlayColor:
              MaterialStateProperty.all(backgroundColor.withAlpha(32)),
          minimumSize: MaterialStateProperty.all(Size.infinite),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
