import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_auth_api.dart';
import 'package:paclub/frontend/modules/auth_module.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class UserBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    logger.wtf('[自动绑定]依赖注入 —— UserBinding');

    Get.lazyPut<FirebaseAuthApi>(() => FirebaseAuthApi());
    Get.lazyPut<AuthModule>(() => AuthModule());
    Get.put<UserController>(UserController());
    // 如果希望是懒加载，则用下面一行（会导致每次打开页面重新刷新内容，因为 Controller 重建了）
    // Get.lazyPut<FirebaseStorageApi>(() => FirebaseStorageApi());
  }
}
