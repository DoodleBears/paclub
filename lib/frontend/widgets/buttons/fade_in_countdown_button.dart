import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/widgets/buttons/buttons.dart';
import 'package:paclub/frontend/widgets/containers/containers.dart';

class FadeInCountdownButton extends StatelessWidget {
  /// [文件说明]
  /// - fade_in_countdown_button 具有淡入动画的 countdown button
  /// - fade_in_scale_container 提供带宽高变形和透明度变化效果的 container
  /// - countdown_button 提供倒计时按钮（本质是TextButton）
  ///
  /// [使用场景]
  /// - 默认隐藏 conutdown button 的情况下希望 countdown button 在出现时能更自然
  ///
  /// [传入参数]
  /// - [isShow] 是否显示（当传入值从 0 变 1 的时候 button 淡入）
  /// - [height] 高度
  /// - [onPressed] 按下后触发的 function
  /// - [text] 按钮文字
  /// - [countdown] 倒计时数字
  /// - [width] 宽度
  /// - [isLoading] 是否加载中（显示圆圈加载动画）
  /// - [icon] 文字左侧的 icon
  /// - [width] 按钮宽度
  /// - [textColor] 文字颜色
  /// - [buttonColor] 按钮颜色
  const FadeInCountdownButton({
    Key? key,
    required this.isShow,
    required this.height,
    required this.onPressed,
    required this.text,
    required this.countdown,
    required this.isLoading,
    this.icon,
    this.width,
    this.textColor,
    this.buttonColor = accentColor,
  }) : super(key: key);

  final bool isShow;
  final double height;
  final double? width;
  final bool isLoading;
  final int countdown;
  final Icon? icon;
  final String text;
  final Color? textColor;
  final Color buttonColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FadeInScaleContainer(
      isShow: isShow, // 判断出现的条件
      width: width ??
          (isLoading // loading 状态下 container 宽度不同
              ? Get.width * 0.4
              : Get.width * 0.8),
      height: height,
      child: CountdownButton(
          onPressed: onPressed,
          countdown: countdown,
          isLoading: isLoading,
          icon: icon,
          text: text,
          textColor: textColor,
          buttonColor: buttonColor),
    );
  }
}
