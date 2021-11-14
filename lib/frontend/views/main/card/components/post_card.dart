import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/card/card_controller.dart';
import 'package:paclub/frontend/views/main/home/components/tags_block.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/post_model.dart';

class PostCard extends GetView<CardController> {
  final PostModel postModel;
  final ScrollController scrollController;
  final double height;

  const PostCard({
    Key? key,
    required this.postModel,
    required this.scrollController,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadowColor!,
            blurRadius: 8.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
        color: AppColors.containerBackground,
      ),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        child: Column(
          crossAxisAlignment: postModel.photoURLs.length == 0
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // NOTE: Post Owner
            postModel.photoURLs.length == 0
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.containerBackground!.withAlpha(192),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
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
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              postModel.ownerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.normalTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            // NOTE: Post Title
            postModel.photoURLs.length == 0
                ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.containerBackground!.withAlpha(192),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 30.0),
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      postModel.title,
                      textAlign: TextAlign.center,
                      maxLines: 2, //最多顯示行數
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            // NOTE: Pack Photo
            postModel.photoURLs.length == 0
                ? SizedBox.shrink()
                : Stack(
                    children: [
                      Container(
                        width: 400,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: postModel.photoURLs[0],
                          cacheKey: postModel.photoURLs[0],
                          maxHeightDiskCache: 2048,
                          memCacheHeight: 1024,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                            alignment: Alignment.topLeft,
                            height: 1.0,
                            child: LinearProgressIndicator(
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
                      // NOTE: Pack User Info & Pack Title
                      Positioned(
                        left: 8.0,
                        right: 20.0,
                        bottom: 5.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NOTE: Pack Owner Avatar and Owner Name
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.containerBackground!.withAlpha(192),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Material(
                                    shape: CircleBorder(),
                                    clipBehavior: Clip.antiAlias,
                                    color: AppColors.profileAvatarBackgroundColor,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 36.0,
                                      height: 36.0,
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
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        postModel.ownerName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.normalTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // NOTE: Pack Name
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.containerBackground!.withAlpha(192),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: const EdgeInsets.only(top: 8.0),
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 4.0,
                              ),
                              child: Text(
                                postModel.title,
                                maxLines: 2, //最多顯示行數
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            // NOTE: Pack Tags
            postModel.tags.length == 0
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 8.0,
                    ),
                    child: TagsBlock(
                      alignment: postModel.photoURLs.length == 0
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      fontSize: 18.0,
                      tags: postModel.tags,
                      tagsNumber: postModel.tags.length,
                    ),
                  ),
            // NOTE: Post Content
            postModel.content == ''
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 14.0,
                      right: 14.0,
                      top: 8.0,
                      bottom: 16.0,
                    ),
                    child: Text(
                      postModel.content,
                      style: TextStyle(
                        fontSize: 20.0, //描述內容，故字體較小
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
