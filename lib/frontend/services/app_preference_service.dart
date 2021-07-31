import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// *  [文件说明]
//    package 用到的 shared_preferences是整合了 Android 和 iOS 本地临时存储库的包
// *  [使用场景]
//    如：保存用户设置的[跟随系统调整黑夜白天模式]等不需要存储与数据库的data（而是跟随手机等移动设备）
class AppPrefsService extends GetxService {
  //  SharedPreferences 的 instance 时需要 await (对应外层调用 init() 时需要 putAsync)
  //  使用 init() 让 AppPrefsService 这个服务初始化并且回传一个 instance 供存储本地 data 时使用
  Future<SharedPreferences> init() async {
    return await SharedPreferences.getInstance();
  }
}
