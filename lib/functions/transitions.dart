import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// **仿 Android 上 Twitter 式的界面 Transition 动画
// Coming(Enter) push进来时执行的入场动画
//    position: (1, 0) -> (0, 0), 位置从右往左 1个页面
// Leaving(Exit) 被pop出去时执行的离场动画
//    scale: (1.0) -> (0.9), 大小缩小成 0.9 倍大
class TopLeftMaskBelowSmallTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve curve,
      Alignment alignment,
      Animation<double> animation, // coming page
      Animation<double> secondaryAnimation, // leaving page
      Widget child) {
    return Stack(
      children: <Widget>[
        // 在中间加一层黑色的透明层
        DarkCurtainFade(
          animation: animation,
          begin: 0.0,
          end: 1.0,
          color: Color(0xbb000000),
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 0.9).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// **仿 iOS 上 Twitter 式的界面 Transition（视差效果）动画
// Coming(Enter) push进来时执行的入场动画
//    position: (1, 0) -> (0, 0), 位置从右往左 1个页面
// Leaving(Exit) 被pop出去时执行的离场动画
//    position: (0, 0) -> (-0.33, 0), 位置从左往右 1/3个页面

class TopLeftMaskBelowLeftTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve curve,
      Alignment alignment,
      Animation<double> animation, // coming page
      Animation<double> secondaryAnimation, // leaving page
      Widget child) {
    return Stack(
      children: <Widget>[
        // 在中间加一层黑色的透明层
        DarkCurtainFade(
          animation: animation,
          begin: 0.0,
          end: 1.0,
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.33, 0.0),
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            ),
            child: child,
          ),
        )
      ],
    );
  }
}

/// **左右水平位移（无视差效果）动画
// Coming(Enter) push进来时执行的入场动画
//    position: (1, 0) -> (0, 0)
// Leaving(Exit) 被pop出去时执行的离场动画
//    positon: (0, 0) -> (-1.0, 0)
class ShiftLeftTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve curve,
      Alignment alignment,
      Animation<double> animation, // coming page
      Animation<double> secondaryAnimation, // leaving page
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SlideTransition(
        // coming page from right to center
        position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOutCubic))
            .animate(animation),
        child: SlideTransition(
          // leaving page from center to left
          position: Tween(begin: Offset.zero, end: Offset(-1.0, 0.0))
              .chain(CurveTween(curve: Curves.easeInOutCubic))
              .animate(secondaryAnimation),
          child: child,
        ),
      ),
    );
  }
}

//** 黑色幕布：制造一个指定颜色的透明度渐变动画，如：从黑色半透明，到全透明，就能模拟 Twitter 的遮罩效果
class DarkCurtainFade extends StatelessWidget {
  const DarkCurtainFade({
    Key key,
    @required this.animation,
    this.begin = 1.0,
    this.end = 0.0,
    this.color = const Color(0x88000000),
  }) : super(key: key);

  final Animation<double> animation;
  final double begin;
  final double end;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: begin, end: end)
          // .chain(CurveTween(curve: Curves.linear))
          .animate(CurvedAnimation(
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
        parent: animation,
      )),
      child: Scaffold(
        backgroundColor: color,
      ),
    );
  }
}
