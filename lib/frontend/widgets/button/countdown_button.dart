import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/widgets/opacity_change_container.dart';

// TODO: 可以加入自定义颜色的设置（允许传入Color），方便未来有需要的时候使用

// *  [文件说明]
//    CountdownButton 是用来简单制作倒计时按钮的 widget
//    使用到 constants 中文字颜色的设定
// *  [使用场景]
//    如重送验证email，为了防止用户频繁重送而设置一个间隔时间
class CountdownButton extends StatelessWidget {
  const CountdownButton({
    Key? key,
    required this.time, //  倒计时时长
    required this.text, // 文字 + after 倒计时时间（如：resend after 30)
    required this.onPressed, //  button 按下的 function
    required this.countdown, //  当前倒计时数字
    required this.isLoading, //  loading判断条件
    this.icon, // button 上的 icon (会在文字左侧)
  }) : super(key: key);

  final int time, countdown;
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        shadowColor: Colors.transparent,
        primary: countdown == 0 ? accentColor : Colors.grey[600],
        backgroundColor: countdown == 0 ? Colors.grey[100] : primaryLightColor,
      ),
      // FittedBox 防止内容溢出
      child: FittedBox(
          fit: BoxFit.contain,
          // 用 Stack 层叠 loading 的转圈动画和非 loading 状态下显示的内容
          // 然后用 OpacityChangeContainer 来交替淡入淡出
          child: Stack(
            alignment: Alignment.center,
            children: [
              // countdown 未开始的时候(一般是网络请求的时候)显示 loading 转圈动画
              OpacityChangeContainer(
                isShow: countdown == time,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5.0,
                ),
              ),
              // countdown 开始的时候(网络请求成功)显示倒计时效果
              OpacityChangeContainer(
                isShow: countdown != time,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    countdown == 0 && icon != null
                        ? Container(
                            margin: EdgeInsets.only(right: 8.0),
                            child: icon,
                          )
                        : const SizedBox.shrink(),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        countdown == 0
                            ? text
                            : countdown == time
                                ? '   '
                                : text + ' after ' + countdown.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
