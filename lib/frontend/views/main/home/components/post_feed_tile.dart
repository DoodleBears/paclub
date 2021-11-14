import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/views/main/home/components/status_button.dart';
import 'package:paclub/frontend/views/main/home/components/tags_block.dart';
import 'package:paclub/frontend/views/main/home/home_hot/home_hot_controller.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_controller.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/logger.dart';

class PostFeedTile extends GetView<HomeHotController> {
  const PostFeedTile({
    Key? key,
    required this.postModel,
  }) : super(key: key);
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(AppColors.normalOverlayColor),
        shape: MaterialStateProperty.all(BeveledRectangleBorder()),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all(AppColors.containerBackground),
      ),
      onPressed: () {
        // print('点击了 $index');
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12.0,
          left: 12.0,
          right: 12.0,
        ),
        child: Column(
          children: [
            // NOTE: Post Info
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头像
                // NOTE: Post 用户头像
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (postModel.ownerUid == AppConstants.uuid) {
                        TabsController tabsController = Get.find<TabsController>();
                        tabsController.setIndex(4);
                      } else {
                        Get.toNamed(
                          Routes.TABS + Routes.USER + postModel.ownerUid,
                          arguments: {
                            'userName': postModel.ownerName,
                            'avatarURL': postModel.ownerAvatarURL,
                          },
                        );
                      }
                    },
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      color: AppColors.profileAvatarBackgroundColor,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 48.0,
                        height: 48.0,
                        imageUrl: postModel.ownerUid != AppConstants.uuid
                            ? postModel.ownerAvatarURL
                            : AppConstants.avatarURL,
                        cacheKey: postModel.ownerUid != AppConstants.uuid
                            ? postModel.ownerAvatarURL
                            : AppConstants.avatarURL,
                        maxHeightDiskCache: 192,
                        memCacheHeight: 128,
                        errorWidget: (context, url, error) {
                          controller.updatePostUserInfo(postModel: postModel);
                          return Center(
                            child: Text(
                              postModel.ownerName.substring(0, 1).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.normalTextColor,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // NOTE: Post User Info 信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 用户名 username 和 uid
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${postModel.ownerName} ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.normalTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${postModel.ownerUid}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.normalGrey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // NOTE: Post Title
                      Text(
                        postModel.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: AppColors.normalTextColor,
                        ),
                      ),
                      // NOTE: Post Content
                      postModel.content == ''
                          ? SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                postModel.content,
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppColors.normalTextColor,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            // NOTE: Post Photos
            postModel.photoURLs.length == 0
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 58.0,
                    ),
                    child: Stack(
                      children: [
                        Material(
                          color: AppColors.normalImageBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 300,
                            width: double.infinity,
                            imageUrl: postModel.photoURLs[0],
                            cacheKey: postModel.photoURLs[0],
                            maxHeightDiskCache: 2048,
                            memCacheHeight: 1024,
                            progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                              alignment: Alignment.bottomLeft,
                              height: 1.0,
                              child: LinearProgressIndicator(
                                backgroundColor: AppColors.containerBackground,
                                color: accentColor,
                                value: downloadProgress.progress ?? 0.0,
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              controller.updatePostUserInfo(postModel: postModel);
                              return Icon(Icons.error);
                            },
                          ),
                        ),
                        postModel.photoURLs.length > 1
                            ? Positioned(
                                right: 8.0,
                                top: 8.0,
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.black.withAlpha(192),
                                    border: Border.all(color: Colors.white, width: 2.0),
                                  ),
                                  child: Text(
                                    '${postModel.photoURLs.length}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
            // NOTE: Post Tags
            postModel.tags.length == 0
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 58.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TagsBlock(
                        tags: postModel.tags,
                        tagsNumber: postModel.tags.length > 3 ? 3 : postModel.tags.length,
                        alignment: WrapAlignment.end,
                      ),
                    ),
                  ),

            // NOTE: Status Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: SizedBox()),
                StatusButton(
                  icon: Icon(
                    Icons.mode_comment_outlined,
                    color: AppColors.normalTextColor,
                    size: 22.0,
                  ),
                  iconClicked: Icon(
                    Icons.mode_comment_rounded,
                    color: primaryColor,
                    size: 22.0,
                  ),
                  number: postModel.commentCount,
                ),
                StatusButton(
                  icon: Icon(
                    Icons.ios_share,
                    color: AppColors.normalTextColor,
                    size: 22.0,
                  ),
                  iconClicked: Icon(
                    Icons.ios_share,
                    color: primaryColor,
                    size: 22.0,
                  ),
                  number: postModel.shareCount,
                ),
                StatusButton(
                  icon: Icon(
                    Icons.favorite_outline_rounded,
                    color: AppColors.normalTextColor,
                    size: 22.0,
                  ),
                  iconClicked: Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                    size: 22.0,
                  ),
                  number: postModel.thumbUpCount,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
