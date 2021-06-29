import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/widgets/fade_in_scale_container.dart';
import 'countdown_button.dart';

// *  [文件说明]
//    fade_in_countdown_button 具有淡入动画的 countdown button
//    fade_in_scale_container 提供带宽高变形和透明度变化效果的 container
//    countdown_button 提供倒计时按钮（本质是TextButton）
// *  [使用场景]
//    默认隐藏 conutdown button 的情况下希望 countdown button 在出现时能更自然
class FadeInCountdownButton extends StatelessWidget {
  final bool isShow; // 是否显示（当传入值从 0 变 1 的时候 button 淡入）
  final double height; // container 高度
  // 以下是给 countdown button 的参数，具体请到 countdown_button.dart 查看
  final bool isLoading;
  final int countdown;
  final int time;
  final Icon icon;
  final String text;
  final VoidCallback onPressed;

  const FadeInCountdownButton({
    Key key,
    @required this.isShow,
    @required this.height,
    @required this.onPressed,
    @required this.text,
    @required this.countdown,
    @required this.time,
    @required this.isLoading,
    this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeInScaleContainer(
      isShow: isShow, // 判断出现的条件
      width: isLoading // loading 状态下 container 宽度不同
          ? Get.width * 0.4
          : Get.width * 0.8,
      height: height,
      child: CountdownButton(
        onPressed: onPressed,
        countdown: countdown,
        isLoading: isLoading,
        icon: icon,
        text: text,
        time: time,
      ),
    );
  }
}
