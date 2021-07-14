import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paclub/widgets/opacity_change_container.dart';

// *  [文件说明]
//    fade_in_scale_container 具有淡入和宽高变化动画的 container
//    如果不需要 scale 的变化，可以使用 opacity_change_container
// *  [使用场景]
//    不仅仅需要透明度淡入的效果，还需要宽高变化时使用
class FadeInScaleContainer extends StatelessWidget {
  final bool isShow; // 判断出现的条件
  final double width; //  container 宽度
  final double height; // container 高度
  final Widget child;
  final Duration scaleDuration; // 宽度和高度变化的动画时长
  final Duration opacityDuration; // 透明度变化的时长
  final Curve scaleCurve; // 宽度和高度变化的动画时长
  final Curve opacityCurve; // 透明度变化的时长

  const FadeInScaleContainer({
    Key? key,
    required this.isShow,
    required this.child,
    required this.height,
    this.width = double.infinity,
    this.scaleDuration = const Duration(milliseconds: 1000),
    this.opacityDuration = const Duration(milliseconds: 500),
    this.scaleCurve = Curves.linearToEaseOut,
    this.opacityCurve = Curves.linearToEaseOut,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OpacityChangeContainer(
      duration: opacityDuration,
      isShow: isShow,
      curve: opacityCurve,
      child: AnimatedContainer(
        curve: scaleCurve,
        duration: scaleDuration,
        // 在给定 isShow 的时候也可以动态赋予 height
        //  在出现过程中, 默认情况 container 高度会由 0 变为给定高度
        height: isShow ? height : 0,
        width: width,
        child: child,
      ),
    );
  }
}
