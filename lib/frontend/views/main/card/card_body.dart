import 'package:drag_like/drag_like.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:ui';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/views/main/card/CardController.dart';

class CardBody extends GetView<CardController> {
  // CardController cardController = Get.find<CardController>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DragLike Example'),
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: GetBuilder<CardController>(
                    builder: (_) {
                      return DragLike(
                        dragController: controller.dragController,
                        duration: Duration(milliseconds: 520),
                        child: controller.imagelist.length <= 0
                            ? Text('加载中...')
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TestDrag(src: controller.imagelist[0])),
                        secondChild: controller.imagelist.length <= 1
                            ? Container()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TestDrag(src: controller.imagelist[1])),
                        screenWidth: 375,
                        outValue: 0.8,
                        dragSpeed: 1000,
                        onChangeDragDistance: (distance) {
                          /// {distance: 0.17511112467447917, distanceProgress: 0.2918518744574653}
                          // print(distance.toString());
                        },
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
                Positioned(
                  left: 0,
                  bottom: MediaQueryData.fromWindow(window).padding.bottom + 50,
                  child: Container(
                    width: MediaQueryData.fromWindow(window).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blueAccent),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.transparent),
                                ),
                              ),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(20)),
                            ),
                            child: Text(
                              'Left',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30),
                            ),
                            onPressed: () async => controller.swipeToLeft()),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.pinkAccent),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.transparent),
                                ),
                              ),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(20)),
                            ),
                            child: Text(
                              'right',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                              ),
                            ),
                            onPressed: () async => controller.swipeToRight()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestDrag extends StatefulWidget {
  final String src;
  const TestDrag({Key? key, required this.src}) : super(key: key);

  @override
  _TestDragState createState() => _TestDragState();
}

class _TestDragState extends State<TestDrag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey,
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.network(
            widget.src,
            fit: BoxFit.cover,
          )),
          // Text(widget.src)
        ],
      ),
    );
  }
}
