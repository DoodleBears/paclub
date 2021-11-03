import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/home/components/pack_feed_tile.dart';
import 'package:paclub/frontend/views/main/home/components/post_feed_tile.dart';
import 'package:paclub/frontend/views/main/home/home_hot/home_hot_controller.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/models/post_model.dart';

class HomeHotPage extends GetView<HomeHotController> {
  const HomeHotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeHotController>(
      builder: (_) {
        return RefreshIndicator(
          backgroundColor: accentColor,
          color: Colors.white,
          onRefresh: controller.loadMoreNewFeed,
          child: Container(
            padding: EdgeInsets.zero,
            color: AppColors.homeListViewBackgroundColor,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: controller.feedList.length,
              itemBuilder: (context, index) {
                // logger.d('build index: $index');
                if (index + 1 == controller.feedList.length) {
                  controller.loadMoreOldFeed(index + 1);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: controller.feedList[index].feedType == 0
                      ? PackFeedTile(
                          packModel: controller.feedList[index] as PackModel,
                        )
                      : PostFeedTile(postModel: controller.feedList[index] as PostModel),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
