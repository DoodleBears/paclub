import 'package:drag_like/drag_like.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:ui';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/views/main/card/card_controller.dart';
import 'package:paclub/frontend/views/main/card/components/drag_card.dart';
import 'package:paclub/utils/logger.dart';

class CardBody extends GetView<CardController> {
  // CardController cardController = Get.find<CardController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('抽卡'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            // NOTE: Flexible 中 Flex 4
            Flexible(
              flex: 4,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: GetBuilder<CardController>(
                  builder: (_) {
                    logger0.d('重新渲染 DragLike');
                    return DragLike(
                      dragController: controller.dragController,
                      duration: Duration(milliseconds: 520),
                      child: controller.imageList.length <= 0
                          ? Text('加載中...')
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: DragCard(src: controller.imageList[0])),
                      secondChild: controller.imageList.length <= 1
                          ? Container()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: DragCard(src: controller.imageList[1])),
                      screenWidth: Get.width,
                      outValue: 0.8,
                      dragSpeed: 1000,
                      onChangeDragDistance: (distance) {},
                      onOutComplete: (type) {
                        print(type);
                      },
                      onScaleComplete: () async =>
                          await controller.removeImage(),
                      onPointerUp: () {},
                    );
                  },
                ),
              ),
            ),
            // NOTE: Expanded 中 Flex 1 说明上面的占 80%，然后下面 Expanded 占据所有空余位置
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    // NOTE: 这里不要用 height 和 width, 用 padding就能做到你要的效果
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    child: GestureDetector(
                        onTap: () async => controller.swipeToLeft(),
                        child: Image.asset('assets/dislike.png')),
                  ),
                  Container(
                    // NOTE: 这里不要用 height 和 width, 用 padding就能做到你要的效果
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    child: GestureDetector(
                        onTap: () async => controller.swipeToRight(),
                        child: Image.asset('assets/like.png')),
                  )
                  // Container(
                  //     height: 60,
                  //     width: 60,
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border: Border.all(color: Colors.white)),
                  //     child: IconButton(
                  //         iconSize: 30,
                  //         onPressed: () async => controller.swipeToRight(),
                  //         icon: Icon(Icons.favorite),
                  //         color: Colors.green))
                  // ElevatedButton(
                  //     style: ButtonStyle(
                  //       backgroundColor:
                  //           MaterialStateProperty.all(Colors.pinkAccent),
                  //       elevation: MaterialStateProperty.all(0),
                  //       shape: MaterialStateProperty.all(
                  //         RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(25),
                  //           side: BorderSide(color: Colors.transparent),
                  //         ),
                  //       ),
                  //       padding:
                  //           MaterialStateProperty.all(EdgeInsets.all(20)),
                  //     ),
                  // child: Text(
                  //   'right',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.w600,
                  //     fontSize: 30,
                  //   ),
                  // ),
                  // onPressed: () async => controller.swipeToRight()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
