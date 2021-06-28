import 'package:flutter/material.dart';

// *  [文件说明]
//    animated_sized_box 是一个带有高度动画的 SizedBox
// *  [使用场景]
//    当 widget 之间需要插入 SizedBox 但希望这个 SizedBox 的大小能够动态控制时候使用
class AnimatedSizedBox extends StatelessWidget {
  final double height;
  // TODO: 添加 width 部分的动画支持

  const AnimatedSizedBox({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800), // 动画时长 0.8s
      curve: Curves.linearToEaseOut, // 动画速度曲线设置为 线性to缓出
      height:
          height, //  接受传入的高度并动态在2个高度之间产生渐变动画(如：高度由10变为20, AnimatedContainer 会自动完成动画)
      child: SizedBox.expand(), //  用 SizedBox.expand() 来填充整个 container
    );
  }
}
