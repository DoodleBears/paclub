import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/card/card_body.dart';
import 'package:paclub/frontend/views/main/card/card_controller.dart';
import 'package:paclub/utils/logger.dart';

class CardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— CardPage');
    Get.put(CardController());
    return CardBody();
  }
}
