import 'package:fluttertoast/fluttertoast.dart';

// 用来 toast 信息
void toast(String loginInfo, {ToastGravity gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
    msg: loginInfo,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity,
    timeInSecForIosWeb: 1,
    fontSize: 16.0,
  );
}
