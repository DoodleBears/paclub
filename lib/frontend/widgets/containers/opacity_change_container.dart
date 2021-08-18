import 'package:flutter/material.dart';

class OpacityChangeContainer extends StatelessWidget {
  /// [文件说明]
  /// - opacity_change_container 用来做透明度变化的 container
  ///
  /// [使用场景]
  /// - 需要简单淡入淡出效果的时候
  ///
  /// [传入参数]
  /// - [child] 子 Widget
  /// - [isShow] 是否显示（透明度动态变化）
  /// - [duration] 透明度变化时间
  /// - [curve] 透明度变化速度曲线
  const OpacityChangeContainer({
    Key? key,
    required this.child,
    required this.isShow,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linearToEaseOut,
  }) : super(key: key);

  final Widget child;
  final bool isShow;
  final Duration duration;
  final Curve curve;

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
