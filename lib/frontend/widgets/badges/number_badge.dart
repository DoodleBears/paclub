import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NumberBadge extends StatelessWidget {
  const NumberBadge({
    Key? key,
    this.color = Colors.red,
    required this.number,
    this.maxNumber = 999,
    this.border,
    this.showWhenZero = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
    this.textStyle,
  }) : super(key: key);

  /// 背景颜色
  final Color color;

  /// 背景颜色
  final BorderSide? border;

  /// 在 [number] 为 0 的时候是否显示
  final bool showWhenZero;

  /// 内间距
  final EdgeInsets padding;

  /// 内间距
  final TextStyle? textStyle;

  /// 显示的数字
  final int number;

  /// 最大显示数字，超过则显示 maxNumber+
  final int maxNumber;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showWhenZero ? true : number != 0,
      child: Center(
        child: Container(
          padding: padding,
          decoration: ShapeDecoration(
            shape: StadiumBorder(
              side: border ?? BorderSide.none,
            ),
            color: color,
          ),
          child: Text(
            number > maxNumber ? '$maxNumber' + '+' : '$number',
            style: textStyle ??
                TextStyle(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
