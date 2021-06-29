import 'package:flutter/material.dart';

// *  [文件说明]
//    opacity_change_container 用来做透明度变化的 container
// *  [使用场景]
//    需要简单淡入淡出效果的时候
class OpacityChangeContainer extends StatelessWidget {
  final Widget child;
  final bool isShow; // 根据 isShow 的值自动做显现隐藏
  final Duration duration;
  final Curve curve;

  const OpacityChangeContainer({
    Key key,
    @required this.child,
    @required this.isShow,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linearToEaseOut,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isShow ? 1.0 : 0.0,
      curve: curve,
      duration: duration,
      child: child,
    );
  }
}
