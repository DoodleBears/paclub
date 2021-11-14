import 'package:drag_like/drag_like.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/card/card_controller.dart';
import 'package:paclub/frontend/views/main/card/components/pack_card.dart';
import 'package:paclub/frontend/views/main/card/components/post_card.dart';
import 'package:paclub/frontend/widgets/buttons/animated_scale_floating_action_button.dart';
import 'package:paclub/frontend/widgets/buttons/scale_floating_action_button.dart';
import 'package:paclub/frontend/widgets/others/no_glow_scroll_behavior.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/r.dart';
import 'package:paclub/utils/logger.dart';

class CardBody extends GetView<CardController> {
  // CardController cardController = Get.find<CardController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('抽卡'),
        actions: [
          IconButton(
            onPressed: () {
              controller.firstLoadFeed();
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 32.0,
            ),
          ),
        ],
      ),
      body: GetBuilder<CardController>(
        builder: (_) {
          return controller.isRefresh
              ? Center(
                  child: AnimatedScaleFloatingActionButton(
                    onPressed: () {},
                    isButtonShow: controller.isRefresh,
                    child: Container(
                      height: 32.0,
                      width: 32.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                      ),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      // NOTE: Flexible 中 Flex 4
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: GetBuilder<CardController>(
                            builder: (_) {
                              logger0.d('重新渲染 DragLike');

                              return DragLike(
                                dragController: controller.dragController,
                                duration: Duration(milliseconds: 520),
                                child: controller.feedList.length <= 0
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              R.appIcon,
                                              height: 80.0,
                                              width: 80.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                                              child: Text(
                                                '沒有更多卡片了',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : controller.feedList[0].feedType == 0
                                        ? PackCard(
                                            scrollController: controller.scrollController1,
                                            height: Get.height * 0.6,
                                            packModel: controller.feedList[0] as PackModel,
                                          )
                                        : PostCard(
                                            scrollController: controller.scrollController1,
                                            height: Get.height * 0.6,
                                            postModel: controller.feedList[0] as PostModel,
                                          ),
                                secondChild: controller.feedList.length <= 1
                                    ? Container()
                                    : controller.feedList[1].feedType == 0
                                        ? PackCard(
                                            scrollController: controller.scrollController2,
                                            height: Get.height * 0.6,
                                            packModel: controller.feedList[1] as PackModel,
                                          )
                                        : PostCard(
                                            scrollController: controller.scrollController2,
                                            height: Get.height * 0.6,
                                            postModel: controller.feedList[1] as PostModel,
                                          ),
                                screenWidth: Get.width,
                                outValue: 0.8,
                                dragSpeed: 1000,
                                onChangeDragDistance: (distance) {},
                                onOutComplete: (type) {
                                  print(type);
                                },
                                onScaleComplete: () async => controller.popFeedList(),
                                onPointerUp: () {},
                              );
                            },
                          ),
                        ),
                      ),
                      // NOTE: Expanded 中 Flex 1 说明上面的占 80%，然后下面 Expanded 占据所有空余位置
                      Expanded(
                        flex: 1,
                        child: GetBuilder<CardController>(
                          builder: (_) {
                            return FadeInScaleContainer(
                              isShow: controller.feedList.length > 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ScaleFloatingActionButton(
                                    shift: 6.6,
                                    backgroundColor: primaryColor,
                                    onPressed: () async => controller.swipeToLeft(),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 48.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ScaleFloatingActionButton(
                                    shift: 6.6,
                                    backgroundColor: accentColor,
                                    onPressed: () async => controller.swipeToRight(),
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      size: 48.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
