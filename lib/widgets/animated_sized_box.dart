import 'package:flutter/material.dart';

// *  [文件说明]
//    animated_sized_box 是一个带有高度动画的 SizedBox
//    由 flutter 原生 AnimatedContainer 来实现动画效果
// *  [使用场景]
//    当 widget 之间需要插入 SizedBox 但希望这个 SizedBox 的大小能够动态控制时候使用
class AnimatedSizedBox extends StatelessWidget {
  final double height; // 在2个高度之间产生动画 (如：高度由10变为20)
  final double width; // 在2个宽度之间产生动画 (如：宽度由10变为20)

  const AnimatedSizedBox({Key key, @required this.height, @required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800), // 动画时长 0.8s
      curve: Curves.linearToEaseOut, // 动画速度曲线设置为 线性to缓出
      height: height,
      width: width,
      child: SizedBox.expand(), //  用 SizedBox.expand() 来填充整个 container
    );
  }
}
