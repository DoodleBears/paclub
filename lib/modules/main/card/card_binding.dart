import 'package:get/get.dart';
import 'package:paclub/modules/main/card/card_controller.dart';
import 'package:paclub/widgets/logger.dart';

// 在进入 Tabs 界面时候，因为已经 Binding, 会自动触发下面的 put，将 Controller 放进 Hashmap
class CardBinding implements Bindings {
  @override
  void dependencies() {
    logger.i('[自动绑定]依赖注入 —— CardBinding');
    Get.lazyPut<CardController>(() => CardController());
  }
}
