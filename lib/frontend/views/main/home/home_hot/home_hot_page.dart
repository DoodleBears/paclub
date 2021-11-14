import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/home/components/pack_feed_tile.dart';
import 'package:paclub/frontend/views/main/home/components/post_feed_tile.dart';
import 'package:paclub/frontend/views/main/home/home_hot/home_hot_controller.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeHotPage extends GetView<HomeHotController> {
  const HomeHotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeHotController>(
      builder: (_) {
        return Container(
          color: AppColors.pageBackground,
          child: RefreshConfiguration(
            enableBallisticLoad: true,
            child: SmartRefresher(
              controller: controller.refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: ClassicHeader(),
              physics: controller.isLoading
                  ? const NeverScrollableScrollPhysics() // 防止加载历史记录时候滚动跳动
                  : const BouncingScrollPhysics(),
              onRefresh: controller.loadMoreNewFeed,
              onLoading: controller.loadMoreOldFeed,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 8.0),
                itemCount: controller.feedList.length,
                itemBuilder: (context, index) {
                  // if (index + 1 == controller.feedList.length) {
                  //   controller.loadMoreOldFeed(index + 1);
                  // }
                  return RepaintBoundary(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: controller.feedList[index].feedType == 0
                          ? PackFeedTile(
                              packModel: controller.feedList[index] as PackModel,
                            )
                          : PostFeedTile(postModel: controller.feedList[index] as PostModel),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
