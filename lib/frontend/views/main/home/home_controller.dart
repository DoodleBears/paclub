import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/utils/logger.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();

  Future<void> navigateToPostPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    Get.toNamed(Routes.WRITEPOST);
  }

  void jumpToTop() {
    if (scrollController.hasClients) {
      scrollController.position.moveTo(0.0);
    }
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
