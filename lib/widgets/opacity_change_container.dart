import 'package:flutter/material.dart';

class OpacityChangeContainer extends StatelessWidget {
  final Widget child;
  final bool isShow; // 根据 isShow 的值自动做显现隐藏
  final Duration duration;

  const OpacityChangeContainer({
    Key key,
    @required this.child,
    @required this.isShow,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isShow ? 1.0 : 0.0,
      curve: Curves.linearToEaseOut,
      duration: duration,
      child: child,
    );
  }
}
