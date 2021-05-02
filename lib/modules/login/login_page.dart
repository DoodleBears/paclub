import 'package:flutter/material.dart';
import 'components/body.dart';

// login 界面开始于这里，Body中用到的 components组件，在 lib/modules/login/components 内
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
