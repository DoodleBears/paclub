import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/modules/splash/splash_controller.dart';
import 'package:paclub/r.dart';

class Body extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 60.0),
      child: SingleChildScrollView(
        // 当我们 builder 中的变量用  _ 下划线来表示的时候，一般是说，我们在这个builder中没用到这个传入的变量的function
        child: Column(
          children: [
            Image.asset(
              R.appIcon, //使用Class调用内置图片地址
              width: Get.width * 0.22,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
