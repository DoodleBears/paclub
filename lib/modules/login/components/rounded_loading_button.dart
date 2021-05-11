import 'package:flutter/material.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/widgets/opacity_change_container.dart';

// 带有 loading 效果的 button，在触发网络请求时，会变成转圈模式
class RoundedLoadingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color, textColor;
  final bool isLoading;
  final double width;
  final double height;

  const RoundedLoadingButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.color = primaryColor,
    this.textColor = Colors.white,
    @required this.isLoading,
    @required this.width,
    this.height = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.linearToEaseOut,
      duration: const Duration(milliseconds: 800),
      width: width,
      height: height,
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
            // [圆形进度条] 改变 Opacity 的动画, 在 Loading 的时候显示
            OpacityChangeContainer(
              isShow: isLoading,
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
            // [LOGIN 文字] 改变 Opacity 的动画, 不在 Loading 的时候显示
            OpacityChangeContainer(
              isShow: !isLoading,
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
