import 'package:cloud_firestore/cloud_firestore.dart';

String chatMessageformatTime(Timestamp timestamp) {
  String timeText = '';
  int hour = timestamp.toDate().toLocal().hour;
  timeText += hour > 12 ? '下午 ${hour - 12}' : '上午 $hour';
  timeText += ':';
  int minute = timestamp.toDate().toLocal().minute;
  timeText += minute < 10 ? '0$minute' : '$minute';

  return timeText;
}

String chatroomListFormatTime(Timestamp timestamp) {
  final currentTime = new DateTime.now().toLocal();
  if (currentTime.day - timestamp.toDate().day > 2) {
    return '${timestamp.toDate().month}月${timestamp.toDate().day}';
  }
  if (currentTime.day - timestamp.toDate().day == 2) {
    return '前天';
  }
  if (currentTime.day - timestamp.toDate().day == 1) {
    return '昨天';
  }

  return chatMessageformatTime(timestamp);
}
