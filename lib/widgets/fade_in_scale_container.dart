import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paclub/widgets/opacity_change_container.dart';

// * 创建一个
class FadeInScaleContainer extends StatelessWidget {
  final bool isShow; // 判断出现的条件
  final bool isScaleDown; // 判定缩短的条件
  final double width;
  final double height;
  final Widget child;

  const FadeInScaleContainer({
    Key key,
    @required this.isShow,
    @required this.isScaleDown,
    @required this.child,
    this.width = double.infinity,
    @required this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OpacityChangeContainer(
      isShow: isShow,
      child: AnimatedContainer(
        curve: Curves.linearToEaseOut,
        duration: const Duration(seconds: 1),
        height: isShow ? height : 0,
        width: width,
        child: child,
      ),
    );
  }
}
