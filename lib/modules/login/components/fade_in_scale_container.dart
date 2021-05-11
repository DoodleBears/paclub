import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/modules/login/components/countdown_button.dart';
import 'package:paclub/modules/login/login_controller.dart';

class FadeInScaleContainer extends StatelessWidget {
  final bool isShow;
  final int countdown;
  final int time;

  final LoginController controller;

  const FadeInScaleContainer({
    Key key,
    @required this.isShow,
    @required this.countdown,
    @required this.time,
    @required this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: Curves.linearToEaseOut,
      duration: const Duration(milliseconds: 800),
      opacity: isShow ? 1.0 : 0.0,
      child: AnimatedContainer(
        curve: Curves.linearToEaseOut,
        duration: const Duration(seconds: 1),
        height: isShow ? 60.0 : 0,
        width: countdown == 30 ? Get.width * 0.3 : Get.width * 0.8,
        child: TextButton(
          onPressed: countdown == 0
              ? () {
                  controller.resendEmail();
                }
              : () {},
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            shadowColor: Colors.transparent,
            primary: countdown == 0 ? accentColor : Colors.grey[600],
            backgroundColor:
                countdown == 0 ? Colors.grey[100] : primaryLightColor,
          ),
          child: CountdownButton(
            text: 'resend',
            sendEmailCountDown: countdown,
            time: time,
          ),
        ),
      ),
    );
  }
}
