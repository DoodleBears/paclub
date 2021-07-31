import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// 带有 loading 效果的 button，在触发网络请求时，会变成转圈模式
class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imageUrl;
  final Color color;
  final double height;

  const RoundedButton({
    Key? key,
    required this.onPressed,
    required this.imageUrl,
    required this.color,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          padding: EdgeInsets.all(Get.height * 0.012),
          shape: CircleBorder(),
        ),
        onPressed: onPressed,
        child: SvgPicture.asset(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
