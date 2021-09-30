import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';

class ChatroomMessageTile extends StatelessWidget {
  String formatTime() {
    String timeText = '';
    int hour = sendTime.toDate().hour;
    timeText += hour > 12 ? '下午 ${hour - 12}' : '上午 $hour';
    timeText += ':';
    int minute = sendTime.toDate().minute;
    timeText += minute < 10 ? '0$minute' : '$minute';

    return timeText;
  }

  ///當資料傳送到聊天室後，要依照時間先後依序排列，並區分資料傳送端(右側)及接收端(左側)
  final String senderName;
  final Timestamp sendTime;
  final String message;
  final bool sendByMe;
  ChatroomMessageTile({
    Key? key,
    required this.message,
    required this.sendByMe,
    required this.senderName,
    required this.sendTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: sendByMe ? 20.0 : 12.0,
        right: sendByMe ? 12.0 : 20.0,
        bottom: 8.0,
        top: 2.0,
      ),
      child: Column(
        crossAxisAlignment:
            sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // TODO 加入用户头像
          //用户名

          Row(
            textDirection: !sendByMe ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 4.0,
                  left: sendByMe ? 0.0 : 4.0,
                  right: sendByMe ? 4.0 : 0.0,
                ),
                child: Text(
                  formatTime(),
                  strutStyle: StrutStyle(
                    height: 1,
                    leading: 0.1,
                    fontSize: 10.0,
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.chatTimestampColor,
                    fontSize: 10.0,
                  ),
                ),
              ),
              Flexible(
                flex: 10,
                child: Container(
                  padding: EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: sendByMe
                        ? AppColors.chatMeBackgroundColor
                        : AppColors.chatOtherBackgroundColor,
                    // gradient: LinearGradient(
                    //   colors: sendByMe
                    //       ? [accentColor, accentDarkColor]
                    //       : [primaryColor, primaryDarkColor],
                    // ),
                  ),
                  child: Text(
                    message,
                    // line-height = fontSize * (leading + height) = 16.0 * 1.1 = 17.6
                    strutStyle: StrutStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
