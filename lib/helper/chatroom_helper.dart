import 'package:cloud_firestore/cloud_firestore.dart';

String getChatRoomId(String strOne, String strTwo) {
  if (strOne.compareTo(strTwo) > 0) {
    return "$strTwo\_$strOne";
  } else {
    return "$strOne\_$strTwo";
  }
}

String chatMessageformatTime(Timestamp timestamp) {
  String timeText = '';
  final DateTime localTimestamp = timestamp.toDate().toLocal();
  int hour = localTimestamp.hour;
  timeText += hour > 12 ? '下午 ${hour - 12}' : '上午 $hour';
  timeText += ':';
  int minute = localTimestamp.minute;
  timeText += minute < 10 ? '0$minute' : '$minute';

  return timeText;
}

String chatroomListFormatTime(Timestamp timestamp) {
  final currentTime = DateTime.now().toLocal();
  final DateTime dataTimestamp = timestamp.toDate().toLocal();
  // 48小时天前
  if (currentTime.subtract(const Duration(days: 2)).millisecondsSinceEpoch >
      dataTimestamp.millisecondsSinceEpoch) {
    return '${dataTimestamp.year}/${dataTimestamp.month}/${dataTimestamp.day}';
  }
  // 24小时 - 48小时前
  if (currentTime.subtract(const Duration(days: 1)).millisecondsSinceEpoch >
      dataTimestamp.millisecondsSinceEpoch) {
    // 和昨天0点比较
    if (currentTime
            .subtract(Duration(
              days: 1,
              hours: currentTime.hour,
              minutes: currentTime.minute,
              seconds: currentTime.second,
              milliseconds: currentTime.millisecond,
              microseconds: currentTime.microsecond,
            ))
            .millisecondsSinceEpoch >
        dataTimestamp.millisecondsSinceEpoch) {
      // 比如前天 14:30，我现在的时间是 14:20 ，也就是47hour50minute 以前
      // 比如前天 23:20，我现在的时间是 14:20 ，也就是39hour 以前
      return '前天';
    } else {
      // 比如昨天 1:30，我现在的时间是 14:20 ，也就是29hour50minute 以前
      // 比如昨天 6:30，我现在的时间是 14:20 ，也就是24hour50minute 以前
      return '昨天';
    }
  }
  // 0 - 24小时 前
  if (currentTime.subtract(const Duration(days: 1)).millisecondsSinceEpoch <
      dataTimestamp.millisecondsSinceEpoch) {
    // 和今天0点比较
    if (currentTime
            .subtract(Duration(
              hours: currentTime.hour,
              minutes: currentTime.minute,
              seconds: currentTime.second,
              milliseconds: currentTime.millisecond,
              microseconds: currentTime.microsecond,
            ))
            .millisecondsSinceEpoch >
        dataTimestamp.millisecondsSinceEpoch) {
      return '昨天';
    } else {
      // 比如今天 1:30，我现在的时间是 14:20 ，也就是12hour50minute 以前
      // 比如今天 6:30，我现在的时间是 14:20 ，也就是7hour50minute 以前
      // 如果是10分钟内
      if (currentTime
              .subtract(const Duration(minutes: 10))
              .millisecondsSinceEpoch <
          dataTimestamp.millisecondsSinceEpoch) {
        if (currentTime.minute > dataTimestamp.minute) {
          // 现在 10:14, data 10:08
          return '${currentTime.minute - dataTimestamp.minute}分钟前';
        } else {
          if (currentTime.minute == dataTimestamp.minute) {
            return '刚刚';
          } else {
            // 现在 10:05, data 9:58
            return '${currentTime.minute + (60 - dataTimestamp.minute)}分钟前';
          }
        }
      }
    }
  }
  // 不是10分钟内，也不是昨天的话
  return chatMessageformatTime(timestamp);
}

String chatMessageDividerFormatTime(
    {required Timestamp current, required Timestamp previous}) {
  final currentTime = current.toDate().toLocal();
  final DateTime previousTime = previous.toDate().toLocal();
  // 48小时天前
  if (currentTime.subtract(const Duration(days: 2)).millisecondsSinceEpoch >
      previousTime.millisecondsSinceEpoch) {
    return '${previousTime.year}年${previousTime.month}月${previousTime.day}日';
  }
  // 24小时 - 48小时前
  if (currentTime.subtract(const Duration(days: 1)).millisecondsSinceEpoch >
      previousTime.millisecondsSinceEpoch) {
    // 和昨天0点比较
    if (currentTime
            .subtract(Duration(
              days: 1,
              hours: currentTime.hour,
              minutes: currentTime.minute,
              seconds: currentTime.second,
              milliseconds: currentTime.millisecond,
              microseconds: currentTime.microsecond,
            ))
            .millisecondsSinceEpoch >
        previousTime.millisecondsSinceEpoch) {
      // 比如前天 14:30，我现在的时间是 14:20 ，也就是47hour50minute 以前
      // 比如前天 23:20，我现在的时间是 14:20 ，也就是39hour 以前
      return '前天';
    } else {
      // 比如昨天 1:30，我现在的时间是 14:20 ，也就是29hour50minute 以前
      // 比如昨天 6:30，我现在的时间是 14:20 ，也就是24hour50minute 以前
      return '昨天';
    }
  }
  // 0 - 24小时 前
  if (currentTime.subtract(const Duration(days: 1)).millisecondsSinceEpoch <
      previousTime.millisecondsSinceEpoch) {
    // 和今天0点比较
    if (currentTime
            .subtract(Duration(
              hours: currentTime.hour,
              minutes: currentTime.minute,
              seconds: currentTime.second,
              milliseconds: currentTime.millisecond,
              microseconds: currentTime.microsecond,
            ))
            .millisecondsSinceEpoch >
        previousTime.millisecondsSinceEpoch) {
      return '昨天';
    }
  }
  return '今天';
}

bool isChatMessageDividerShow(
    {required Timestamp current, required Timestamp previous}) {
  final currentTime = current.toDate().toLocal();
  final DateTime previousTime = previous.toDate().toLocal();

  // 如果是是同一天
  if ((currentTime.day == previousTime.day &&
      currentTime.subtract(const Duration(days: 2)).millisecondsSinceEpoch <
          previousTime.millisecondsSinceEpoch)) {
    return false;
  }
  return true;
}
