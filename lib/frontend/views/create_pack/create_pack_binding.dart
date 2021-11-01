import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_storage_api.dart';
import 'package:paclub/backend/api/pack_api.dart';
import 'package:paclub/backend/repository/remote/firebase_storage_repository.dart';
import 'package:paclub/backend/repository/remote/pack_repository.dart';
import 'package:paclub/frontend/modules/pack_module.dart';
import 'package:paclub/frontend/views/create_pack/create_pack_controller.dart';
import 'package:paclub/utils/logger.dart';

// 实现 Bindings 来用于 getPages 初始化时候 binding 用
// 采用 lazyPut，仅当需要用到该 Controller 时候注册 Controller（事先binding好，可以提高效率
// 按住 ctrl 点击 class 名，可以跳转到用 Class 的地方
class CreatePackBinding implements Bindings {
  @override
  void dependencies() {
    logger.wtf('[自动绑定]依赖注入 —— CreatePackBinding');

    /// Controller 用到的 Module 和 API
    Get.put<FirebaseStorageRepository>(FirebaseStorageRepository());
    Get.put<FirebaseStorageApi>(FirebaseStorageApi());

    Get.lazyPut<PackRepository>(() => PackRepository());
    Get.lazyPut<PackApi>(() => PackApi());
    Get.lazyPut<PackModule>(() => PackModule());

    Get.lazyPut<CreatePackController>(() => CreatePackController());
  }
}
