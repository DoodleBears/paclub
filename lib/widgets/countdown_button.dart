import 'package:flutter/material.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/widgets/opacity_change_container.dart';

class CountdownButton extends StatelessWidget {
  const CountdownButton({
    Key key,
    @required this.time,
    @required this.text,
    @required this.onPressed,
    @required this.countdown,
    @required this.isLoading,
    @required this.icon,
  }) : super(key: key);

  final int time, countdown;
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    // logger.i(countdown);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        shadowColor: Colors.transparent,
        primary: countdown == 0 ? accentColor : Colors.grey[600],
        backgroundColor: countdown == 0 ? Colors.grey[100] : primaryLightColor,
      ),
      child: FittedBox(
          fit: BoxFit.contain,
          child: Stack(
            alignment: Alignment.center,
            children: [
              OpacityChangeContainer(
                isShow: countdown == time,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5.0,
                ),
              ),
              OpacityChangeContainer(
                isShow: countdown != time,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    countdown == 0
                        ? Container(
                            margin: EdgeInsets.only(right: 8.0),
                            child: icon,
                          )
                        : const SizedBox.shrink(),
                    Text(
                      countdown == 0
                          ? text
                          : countdown == time
                              ? ''
                              : text + ' after ' + countdown.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
