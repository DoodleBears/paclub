import 'package:fluttertoast/fluttertoast.dart';

// 用来 toast 信息
void toast(String loginInfo, {ToastGravity gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
    msg: loginInfo,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity,
    timeInSecForIosWeb: 2,
    fontSize: 18.0,
  );
}
