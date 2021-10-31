import 'package:drag_like/drag_like.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';

class CardController extends GetxController {
  String testString = '这是从controller获得的string';
  final DragController dragController = DragController();
  final List imageList = [];
  final List imageData = [
    'https://pbs.twimg.com/profile_images/1334699705738129409/EulKSHSa_400x400.jpg',
    'https://imgur.dcard.tw/SrKCxceh.jpg',
    'https://a.ksd-i.com/a/2021-08-18/137064-916244.jpg',
    'https://staticg.sportskeeda.com/editor/2021/10/fa8ca-16350181245645-1920.jpg',
    'https://www.kpopn.com/upload/2897dd0a0a7f703f89d8.jpg',
    'https://a.ksd-i.com/a/2020-08-24/129506-868318.jpg',
    'https://www.voguehk.com/media/2021/03/91337426_241149467285324_685518477112998213_n-1024x1280.jpg',
    'https://news.openpoint.com.tw/images/channel_article/994ee806c78e9b5e0f769e1bab24b950f500a8454d79271ba5245e6283b1e9fb.jpg',
  ];

  Future<void> removeImage() async {
    imageList.remove(imageList[0]);
    update();
    if (imageList.length == 0) {
      await loadData();
    }
  }

  Future<void> loadData() async {
    logger.i('开始加载卡片');
    await Future.delayed(const Duration(milliseconds: 2000));
    imageList.addAll(imageData);
    update();
    logger.i('finish card load');
  }

  void swipeToRight() {
    if (imageList.length > 0) {
      dragController.toRight();
    }
  }

  void swipeToLeft() {
    if (imageList.length > 0) {
      dragController.toLeft();
    }
  }

  @override
  void onInit() {
    logger.i('启用 CardController');
    loadData();
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 CardController');
    super.onClose();
  }
}
