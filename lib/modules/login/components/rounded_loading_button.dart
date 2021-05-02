import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/theme/app_theme.dart';

// 带有 loading 效果的 button，在触发网络请求时，会变成转圈模式
class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color, textColor;
  final bool isLoading;

  const RoundedButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.color = primaryColor,
    this.textColor = Colors.white,
    @required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.8,
      height: 60.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          primary: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 12.0),
          // 去除 Button 默认的阴影
          shadowColor: Colors.transparent,
        ),
        child: isLoading
            ? FittedBox(
                fit: BoxFit.fitHeight,
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: textColor,
                ),
              ),
        onPressed: onPressed,
      ),
    );
  }
}
