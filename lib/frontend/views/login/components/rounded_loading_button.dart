import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/widgets/buttons/rounded_button.dart';
import 'package:paclub/frontend/widgets/containers/containers.dart';

class RoundedLoadingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color, textColor;
  final bool isLoading;
  final double? width, height;
  final OutlinedBorder? shape;

  /// [文件说明]
  /// - 带有 loading 效果的 button
  ///
  /// [使用场景]
  /// - 一般用于触发网络请求时，会变成转圈模式
  ///
  /// [传入参数]
  /// - [onPressed] 按下按钮后调用的 function
  /// - [text] 按钮上的文字
  /// - [color] 按钮颜色
  /// - [textColor] 按钮上的文字的颜色
  /// - [isLoading] 按钮加载状态，传入 true 显示转圈 ｜ false显示文字
  /// - [width] 按钮宽度
  /// - [height] 按钮高度
  const RoundedLoadingButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color = primaryColor,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.width,
    this.height,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInScaleContainer(
      scaleDuration: const Duration(milliseconds: 800),
      opacityDuration: const Duration(milliseconds: 800),
      width: width ?? Get.width * 0.8,
      height: height ?? Get.height * 0.08,
      isShow: true,
      child: RoundedButton(
        color: color,
        onPressed: onPressed,
        shape: shape,
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
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
