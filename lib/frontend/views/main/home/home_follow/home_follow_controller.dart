import 'package:get/get.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeFollowController extends GetxController {
  final RefreshController refreshController = RefreshController();
  List<PackModel> packList = <PackModel>[];

  // TODO: 获取更多的 Pack
  void loadMorePack() {}

  // TODO: 刷新 Post
  void refreshPack() {}

  @override
  void onInit() {
    logger.i('启用 HomeFollowController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 HomeFollowController');
    super.onClose();
  }
}
