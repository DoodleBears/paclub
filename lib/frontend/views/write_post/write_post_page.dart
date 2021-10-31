import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/views/write_post/write_post_body.dart';
import 'package:paclub/utils/logger.dart';

class WritePostPage extends StatelessWidget {
  const WritePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— WritePostPage');
    return GetBuilder<AppController>(
      builder: (_) {
        return WritePostBody();
      },
    );
  }
}
