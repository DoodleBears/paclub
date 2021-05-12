import 'package:flutter/material.dart';

class AnimatedSizedbox extends StatelessWidget {
  final double height;

  const AnimatedSizedbox({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.linearToEaseOut,
      height: height,
      child: SizedBox.expand(),
    );
  }
}
