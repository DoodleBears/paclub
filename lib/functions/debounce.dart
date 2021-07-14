import 'dart:async';

/// 函数防抖
///
/// [func]: 要执行的方法
/// [delay]: 要迟延的时长
const Duration defaultDelay = Duration(milliseconds: 2000);
Function inputDebounce(Function func, [Duration delay = defaultDelay]) {
  late Timer timer;
  Function target = () {
    if (timer.isActive) {
      timer.cancel();
    }
    timer = Timer(delay, () {
      func.call();
    });
  };
  return target;
}
