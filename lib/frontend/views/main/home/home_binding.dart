import 'package:get/get.dart';
import 'package:paclub/backend/api/pack_api.dart';
import 'package:paclub/backend/api/post_api.dart';
import 'package:paclub/backend/api/user_api.dart';
import 'package:paclub/backend/repository/remote/pack_repository.dart';
import 'package:paclub/backend/repository/remote/post_repository.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/frontend/modules/pack_module.dart';
import 'package:paclub/frontend/modules/post_module.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/views/main/home/home_controller.dart';
import 'package:paclub/frontend/views/main/home/home_follow/home_follow_controller.dart';
import 'package:paclub/frontend/views/main/home/home_hot/home_hot_controller.dart';
import 'package:paclub/utils/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    logger.wtf('[自动绑定]依赖注入 —— HomeBinding');

    /// Controller 用到的 Module 和 API
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<UserApi>(() => UserApi());
    Get.lazyPut<UserModule>(() => UserModule());
    Get.lazyPut<PackRepository>(() => PackRepository());
    Get.lazyPut<PackApi>(() => PackApi());
    Get.lazyPut<PackModule>(() => PackModule());
    Get.lazyPut<PostRepository>(() => PostRepository());
    Get.lazyPut<PostApi>(() => PostApi());
    Get.lazyPut<PostModule>(() => PostModule());

    /// View 用到的 Controller
    Get.put<HomeController>(HomeController());
    Get.put<HomeHotController>(HomeHotController());
    Get.put<HomeFollowController>(HomeFollowController());
    // 如果希望是懒加载，则用下面一行（会导致每次打开页面重新刷新内容，因为 Controller 重建了）
    // Get.lazyPut<HomeController>(() => HomeController());
  }
}
