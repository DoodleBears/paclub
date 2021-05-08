import 'package:flutter/material.dart';
import 'package:paclub/constants/constants.dart';

// 在登录界面提供注册界面的跳转，反之亦然
class AlreadHaveAnAccoutCheck extends StatelessWidget {
  final bool login;
  final GestureTapCallback onTap;
  const AlreadHaveAnAccoutCheck({
    Key key,
    this.login,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have a Account？" : "Already have a Account ? ",
          style: TextStyle(
            color: primaryDarkColor,
            fontSize: 14.0,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            login ? 'Sign up' : "Sign in",
            style: TextStyle(
              color: primaryDarkColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        )
      ],
    );
  }
}
