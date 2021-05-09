import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// 带有 loading 效果的 button，在触发网络请求时，会变成转圈模式
class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imageUrl;
  final Color color;

  const RoundedButton({
    Key key,
    @required this.onPressed,
    @required this.imageUrl,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // width: 60.0,
      // height: 60.0,
      // color: color,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.all(10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      ),
      onPressed: onPressed,

      child: SvgPicture.asset(
        imageUrl,
        width: 40.0,
        height: 40.0,
        // fit: BoxFit.contain,
      ),
    );
  }
}
