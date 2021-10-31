import 'package:flutter/material.dart';
import 'package:paclub/frontend/widgets/containers/opacity_change_container.dart';

class StadiumLoadingButton extends StatelessWidget {
  const StadiumLoadingButton({
    Key? key,
    required this.buttonColor,
    required this.child,
    required this.isLoading,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
    this.loadingWidget,
    this.height,
  }) : super(key: key);

  final double? height;
  final bool isLoading;
  final Widget? loadingWidget;
  final Color buttonColor;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          color: buttonColor,
        ),
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // [圆形进度条] 改变 Opacity 的动画, 在 Loading 的时候显示
              OpacityChangeContainer(
                isShow: isLoading,
                child: SizedBox(
                  width: height,
                  height: height,
                  child: loadingWidget ??
                      CircularProgressIndicator(
                        // 设置为白色（保持不变的 Animation，一直为白色
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        // 进度条背后背景的颜色（圆圈底下的部分）
                        // backgroundColor: Colors.grey[300],
                        strokeWidth: 3.0,
                      ),
                ),
              ),
              // [LOGIN 文字] 改变 Opacity 的动画, 不在 Loading 的时候显示
              OpacityChangeContainer(
                isShow: !isLoading,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
