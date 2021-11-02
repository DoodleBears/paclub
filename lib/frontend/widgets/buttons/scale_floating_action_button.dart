import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';

class ScaleFloatingActionButton extends StatefulWidget {
  const ScaleFloatingActionButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);
  final Function onPressed;
  final Widget child;
  @override
  State<ScaleFloatingActionButton> createState() {
    return _ScaleFloatingActionButtonState();
  }
}

class _ScaleFloatingActionButtonState extends State<ScaleFloatingActionButton> {
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
              return 4.0;
            }),
            splashFactory: NoSplash.splashFactory,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
