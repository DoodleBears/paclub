import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefsController extends GetxService {
  // 在 App 启动时被初始化，主要用于检测用户登录状态（用户 Status）
  Future<SharedPreferences> init() async {
    return await SharedPreferences.getInstance();
  }
}
