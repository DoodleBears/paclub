import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';

// 带有 loading 效果的 button，在触发网络请求时，会变成转圈模式
class RoundedLoadingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color, textColor;
  final bool isLoading;

  const RoundedLoadingButton({
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
        onPressed: onPressed,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            // [圆形进度条] 改变 Opacity 的动画
            AnimatedOpacity(
              // 当正在 loading 的时候, 进度条透明度设置为 1(显现), 否则为0(消失)
              opacity: isLoading ? 1 : 0,
              curve: Curves.easeInOutCubic,
              duration: Duration(milliseconds: 300),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                // 圆形进度条
                child: CircularProgressIndicator(
                  // 设置为白色（保持不变的 Animation，一直为白色
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  // 进度条背后背景的颜色（圆圈底下的部分）
                  // backgroundColor: Colors.grey[300],
                  strokeWidth: 5.0,
                ),
              ),
            ),
            // [LOGIN 文字] 改变 Opacity 的动画
            AnimatedOpacity(
              // 当正在 loading 的时候，文字的透明度设置为为0(消失), 否则为1(显现)
              opacity: isLoading ? 0 : 1,
              curve: Curves.easeInOutCubic,
              duration: Duration(milliseconds: 300),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
