import 'dart:async';
import 'package:paclub/utils/logger.dart';

/// [文件说明]
/// - 常用的 Timer 计时器（如：倒计时等）
class AppTimer {
  int _time = 0;

  /// [每秒触发的倒计时计时器]
  /// - [interval] 每 n 秒触发一次
  /// - [time] 触发 n 次
  /// - [function] 每次触发的 function
  void setCountdownTimer(
      {int interval = 1, int time = 30, Function? function}) {
    late Timer timer;
    this._time = time;
    logger.d('倒计时开始: 每$interval秒触发一次，触发$time次');
    timer = Timer.periodic(Duration(seconds: interval), (t) {
      if (_time > 0) {
        _time--;
        if (function != null) function();
      } else {
        timer.cancel();
        _time = 0;
      }
    });
  }
}
