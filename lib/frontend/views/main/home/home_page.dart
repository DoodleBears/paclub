import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/home/home_body.dart';
import 'package:paclub/frontend/views/main/home/home_controller.dart';
import 'package:paclub/utils/logger.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— HomePage');
    Get.put(HomeController());
    return HomeBody();
  }
}
