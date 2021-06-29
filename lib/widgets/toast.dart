import 'package:fluttertoast/fluttertoast.dart';

// 用来 toast 信息
// *  [使用方式] toast(文本内容, 可选{toast出现的位置,  )
void toast(String message, {ToastGravity gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity,
    timeInSecForIosWeb: 2,
    fontSize: 18.0,
  );
}
