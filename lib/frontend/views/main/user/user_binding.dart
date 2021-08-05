import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class UserBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    logger.i('[自动绑定]依赖注入 —— UserBinding');

    /// 如: `自动登录`, `黑夜模式`等
  }
}
