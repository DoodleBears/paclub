import 'package:fluttertoast/fluttertoast.dart';

// 用来 toast 信息
void toast(String loginInfo) {
  Fluttertoast.showToast(
      msg: loginInfo,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}
