import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/main/home/components/status_button.dart';
import 'package:paclub/frontend/views/main/home/components/tags_block.dart';
import 'package:paclub/frontend/views/main/home/home_hot/home_hot_controller.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/r.dart';
import 'package:paclub/utils/logger.dart';

// FIXME: 修复排版样式
class PackFeedTile extends GetView<HomeHotController> {
  const PackFeedTile({
    Key? key,
    required this.packModel,
  }) : super(key: key);
  final PackModel packModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(AppColors.packOverlayColor),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.all(AppColors.packContainerBackgroundColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          )),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: AppColors.packBackgroundColor,
          ),
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 12.0,
            bottom: 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NOTE: pack photo
              packModel.photoURL == ''
                  ? SizedBox.shrink()
                  : Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          side: BorderSide(
                            color: AppColors.packContainerBackgroundColor!,
                            width: 5.5,
                          )),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 200.0,
                        maxHeightDiskCache: 2048,
                        memCacheHeight: 1024,
                        width: double.infinity,
                        imageUrl: packModel.photoURL,
                        cacheKey: packModel.photoURL,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                          alignment: Alignment.bottomLeft,
                          height: 1.0,
                          child: LinearProgressIndicator(
                            color: accentColor,
                            value: downloadProgress.progress ?? 0.0,
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          // FIXME: 当Pack封面没正确加载的时候，
                          return Icon(Icons.error);
                        },
                      ),
                    ),
              // NOTE: Pack Name
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 2.0,
                    left: 4.0,
                  ),
                  child: Text(
                    packModel.packName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: AppColors.normalTextColor,
                    ),
                  ),
                ),
              ),
              // NOTE: Pack Owner Avatar and Name
              Padding(
                padding: const EdgeInsets.only(
                  top: 2.0,
                  left: 4.0,
                ),
                child: Row(
                  children: [
                    Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      color: AppColors.chatAvatarBackgroundColor,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 24.0,
                        height: 24.0,
                        maxHeightDiskCache: 512,
                        memCacheHeight: 256,
                        imageUrl: packModel.ownerUid != AppConstants.uuid
                            ? packModel.ownerAvatarURL
                            : AppConstants.avatarURL,
                        cacheKey: packModel.ownerUid != AppConstants.uuid
                            ? packModel.ownerAvatarURL
                            : AppConstants.avatarURL,
                        errorWidget: (context, url, error) {
                          logger3.e('加载头像失败');
                          controller.updatePackUserInfo(packModel: packModel);
                          return Center(
                            child: Text(
                              packModel.ownerName.substring(0, 1),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: AppColors.normalTextColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          packModel.ownerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: AppColors.normalTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // NOTE: Pack Tags
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: TagsBlock(
                  tags: packModel.tags,
                  tagsNumber: packModel.tags.length,
                ),
              ),

              // NOTE: Status Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // verticalDirection: VerticalDirection.up,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 32.0,
                      child: Image.asset(
                        R.appIcon,
                      ),
                    ),
                  ),
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
                    number: packModel.commentCount,
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
                    number: packModel.shareCount,
                  ),
                  StatusButton(
                    icon: Icon(
                      Icons.favorite_outline_rounded,
                      color: AppColors.normalTextColor,
                      size: 22.0,
                    ),
                    iconClicked: Icon(
                      Icons.favorite_rounded,
                      color: accentColor,
                      size: 22.0,
                    ),
                    number: packModel.thumbUpCount,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
