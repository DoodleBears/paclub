import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paclub/frontend/widgets/containers/opacity_change_container.dart';

class FadeInScaleContainer extends StatelessWidget {
  /// [文件说明]
  /// - fade_in_scale_container 具有淡入和宽高变化动画的 container
  /// - 如果不需要 scale 的变化，可以使用 opacity_change_container
  ///
  /// [使用场景]
  /// - 不仅仅需要透明度淡入的效果，还需要宽高变化时使用
  ///
  /// [传入参数]
  /// - [isShow] 是否显示
  /// - [child] 子 Widget
  /// - [height] 高度（动态变化）
  /// - [width] 宽度（动态变化）
  /// - [scaleDuration] 宽高变化时间
  /// - [opacityDuration] 透明度变化时间
  /// - [scaleCurve] 宽高变化速度曲线
  /// - [opacityCurve] 透明度变化速度曲线
  const FadeInScaleContainer({
    Key? key,
    required this.isShow,
    this.child,
    this.height,
    this.width,
    this.scaleDuration = const Duration(milliseconds: 1000),
    this.opacityDuration = const Duration(milliseconds: 500),
    this.scaleCurve = Curves.linearToEaseOut,
    this.opacityCurve = Curves.linearToEaseOut,
    this.color,
  }) : super(key: key);

  final bool isShow;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final Duration scaleDuration;
  final Duration opacityDuration;
  final Curve scaleCurve;
  final Curve opacityCurve;

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
        height: isShow ? height : 0.0,
        width: width,
        child: child,
        color: color,
      ),
    );
  }
}
