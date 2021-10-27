import 'package:flutter/material.dart';

class ScaleFloatingActionButton extends StatefulWidget {
  const ScaleFloatingActionButton({Key? key, required this.onPressed})
      : super(key: key);
  final Function onPressed;
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
          ..translate(isButtonPressed ? 4.0 : 0.0, isButtonPressed ? 4.0 : 0.0)
          ..scale(isButtonPressed ? 0.82 : 1.0, isButtonPressed ? 0.82 : 1.0),
        child: FloatingActionButton(
          onPressed: () {},
          elevation: 4.0,
          hoverElevation: 0.0,
          highlightElevation: 2.0,
          focusElevation: 0.0,
          child: Icon(
            Icons.post_add,
            color: Colors.white,
            size: 32.0,
          ),
        ),
      ),
    );
  }
}
