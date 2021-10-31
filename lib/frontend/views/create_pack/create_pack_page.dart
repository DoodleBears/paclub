import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/create_pack/create_pack_body.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/utils/logger.dart';

class CreatePackPage extends StatelessWidget {
  const CreatePackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— CreatePackPage');
    return GetBuilder<AppController>(
      builder: (_) {
        return CreatePackBody();
      },
    );
  }
}
