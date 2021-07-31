import 'package:fluttertoast/fluttertoast.dart';

/// [toast提示信息在顶部]
///
/// [传入参数]
/// - [message] 提示信息
void toastTop(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 2,
    fontSize: 18.0,
  );
}

/// [toast提示信息在中间]
///
/// [传入参数]
/// - [message] 提示信息
void toastCenter(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    fontSize: 18.0,
  );
}

/// [toast提示信息在底部]
///
/// [传入参数]
/// - [message] 提示信息
void toastBottom(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 2,
    fontSize: 18.0,
  );
}
