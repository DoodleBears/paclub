import 'package:flutter/material.dart';

class CountdownButton extends StatelessWidget {
  const CountdownButton({
    Key key,
    @required this.sendEmailCountDown,
    @required this.time,
    @required this.text,
  }) : super(key: key);

  final int sendEmailCountDown;
  final int time;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: sendEmailCountDown == 30
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 5.0,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sendEmailCountDown == 0
                    ? Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.send),
                      )
                    : const SizedBox.shrink(),
                Text(
                  sendEmailCountDown == 0
                      ? text
                      : text + ' after ' + sendEmailCountDown.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
    );
  }
}
