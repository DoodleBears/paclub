import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';

class ChatroomMessageTile extends StatelessWidget {
  ///當資料傳送到聊天室後，要依照時間先後依序排列，並區分資料傳送端(右側)及接收端(左側)
  final String senderName;
  final String message;
  final bool sendByMe;
  ChatroomMessageTile({
    Key? key,
    required this.message,
    required this.sendByMe,
    required this.senderName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        bottom: 8.0,
        top: 2.0,
      ),
      child: Column(
        crossAxisAlignment:
            sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: sendByMe ? 0.0 : 4.0,
                right: sendByMe ? 4.0 : 0.0,
                bottom: 4.0),
            child: Text(
              senderName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              strutStyle: StrutStyle(
                height: 1,
                leading: 0.1,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                gradient: LinearGradient(
                  colors: sendByMe
                      ? [accentColor, accentDarkColor]
                      : [primaryColor, primaryDarkColor],
                )),
            child: Text(
              message,
              // line-height = fontSize * (leading + height) = 16.0 * 1.1 = 17.6
              strutStyle: StrutStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
