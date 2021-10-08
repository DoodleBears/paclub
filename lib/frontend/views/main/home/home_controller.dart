import 'package:get/get.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/utils/logger.dart';

class HomeController extends GetxController {
  // FIXME: AuthModule 在完成认证后关闭了，为什么还能再这里被find到？
  // 既然关闭了，又怎么能使用？内存中是怎么样的
  // 感觉是在新页面跳转的时候，find先获取到了object，之后AuthModule 才关闭的
  // 算是获取到了一个临时的？ AuthModule 的 object，在切换到其他tab再切换回主页时就会报错
  final AuthModule authModule = Get.find();
  // final AuthModule authModule = Get.find();
  String testString = '这是从controller获得的string';

  Future<void> signOut() async {
    await authModule.signOut();
  }

  @override
  void onInit() {
    logger.i('启用 HomeController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 HomeController');
    super.onClose();
  }
}
