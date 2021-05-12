import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/widgets/widgets.dart';

class FadeInCountdownButton extends StatelessWidget {
  final bool isShow;
  final bool isLoading;
  final int countdown;
  final int time;
  final double height;
  final Icon icon;
  final String text;
  final VoidCallback onPressed;

  const FadeInCountdownButton({
    Key key,
    @required this.isShow,
    @required this.height,
    @required this.onPressed,
    @required this.text,
    this.countdown,
    this.time,
    @required this.isLoading,
    this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeInScaleContainer(
      isShow: isShow, // 判断出现的条件
      width: isLoading
          ? Get.width * 0.4 // 缩短 时候的长度
          : Get.width * 0.8, // 正常 时候的长度
      height: Get.height * 0.08,
      child: CountdownButton(
        onPressed: onPressed,
        countdown: countdown ?? 0,
        isLoading: isLoading,
        icon: icon,
        text: text,
        time: time ?? 1,
      ),
    );
  }
}
