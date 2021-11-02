import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';

class AnimatedScaleFloatingActionButton extends StatefulWidget {
  const AnimatedScaleFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.isButtonShow = true,
  }) : super(key: key);
  final Function onPressed;
  final bool isButtonShow;
  final Widget child;
  @override
  State<AnimatedScaleFloatingActionButton> createState() {
    return _AnimatedScaleFloatingActionButtonState();
  }
}

class _AnimatedScaleFloatingActionButtonState extends State<AnimatedScaleFloatingActionButton> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) {
        setState(() {
          isButtonPressed = true;
        });
      },
      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
        if (isButtonPressed == true) {
          setState(() {
            isButtonPressed = false;
          });
        }
      },
      onPanCancel: () {
        setState(() {
          isButtonPressed = false;
        });
        widget.onPressed();
      },
      child: AnimatedContainer(
        height: widget.isButtonShow ? 60.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(
            isButtonPressed ? 5.4 : 0.0,
            isButtonPressed ? 5.4 : 0.0,
          )
          ..scale(isButtonPressed ? 0.82 : 1.0, isButtonPressed ? 0.82 : 1.0),
        child: ElevatedButton(
          onPressed: () {},
          clipBehavior: Clip.hardEdge,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(accentColor),
            padding: MaterialStateProperty.all(EdgeInsets.all(12.0)),
            shape: MaterialStateProperty.all(CircleBorder()),
            elevation: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return 2.0;
              }
              return widget.isButtonShow ? 4.0 : 0.0;
            }),
            splashFactory: NoSplash.splashFactory,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCirc,
            transform: widget.isButtonShow
                ? (Matrix4.identity()
                  ..translate(
                    0.0,
                    -50.0,
                  ))
                : Matrix4.identity()
              ..translate(
                0.0,
                50.0,
              ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
