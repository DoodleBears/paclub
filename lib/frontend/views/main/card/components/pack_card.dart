import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/main/card/card_controller.dart';
import 'package:paclub/frontend/views/main/home/components/tags_block.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/r.dart';

class PackCard extends GetView<CardController> {
  final ScrollController scrollController;
  final PackModel packModel;
  final double height;
  const PackCard({
    Key? key,
    required this.scrollController,
    required this.packModel,
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
          crossAxisAlignment:
              packModel.photoURL == '' ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            // NOTE: Pack Icon
            packModel.photoURL == ''
                ? Container(
                    padding: const EdgeInsets.all(4.0),
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(164),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image.asset(
                      R.appIcon,
                      height: 36.0,
                      width: 36.0,
                    ),
                  )
                : SizedBox.shrink(),
            // NOTE: Pack Owner Avatar and Owner Name
            packModel.photoURL == ''
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
                          color: AppColors.chatAvatarBackgroundColor,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 36.0,
                            height: 36.0,
                            maxHeightDiskCache: 512,
                            memCacheHeight: 128,
                            imageUrl: AppConstants.uuid == packModel.ownerUid
                                ? AppConstants.avatarURL
                                : packModel.ownerAvatarURL,
                            cacheKey: AppConstants.uuid == packModel.ownerUid
                                ? AppConstants.avatarURL
                                : packModel.ownerAvatarURL,
                            errorWidget: (context, url, error) {
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
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              packModel.ownerName,
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
            // NOTE: Pack Name
            packModel.photoURL == ''
                ? Container(
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
                      packModel.packName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            // NOTE: Pack If have Image
            packModel.photoURL == ''
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
                          maxHeightDiskCache: 2048,
                          memCacheHeight: 1024,
                          width: double.infinity,
                          imageUrl: packModel.photoURL,
                          cacheKey: packModel.photoURL,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                            alignment: Alignment.topLeft,
                            height: 1.0,
                            child: LinearProgressIndicator(
                              color: accentColor,
                              value: downloadProgress.progress ?? 0.0,
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                      // NOTE: Pack Owner and Pack Title
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
                                    color: AppColors.chatAvatarBackgroundColor,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 36.0,
                                      height: 36.0,
                                      maxHeightDiskCache: 512,
                                      memCacheHeight: 256,
                                      imageUrl: packModel.ownerUid != AppConstants.uuid
                                          ? packModel.ownerAvatarURL
                                          : AppConstants.avatarURL,
                                      cacheKey: packModel.ownerUid != AppConstants.uuid
                                          ? packModel.ownerAvatarURL
                                          : AppConstants.avatarURL,
                                      errorWidget: (context, url, error) {
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
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        packModel.ownerName,
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
                                packModel.packName,
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
                      // NOTE: Pack Icon
                      Positioned(
                        left: 10.0,
                        top: 10.0,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(164),
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Image.asset(
                            R.appIcon,
                            height: 36.0,
                            width: 36.0,
                          ),
                        ),
                      ),
                    ],
                  ),
            // NOTE: Pack Info
            packModel.tags.length == 0
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 8.0,
                    ),
                    child: TagsBlock(
                      alignment:
                          packModel.photoURL == '' ? WrapAlignment.center : WrapAlignment.start,
                      fontSize: 18.0,
                      spacing: 2.0,
                      runSpacing: 2.0,
                      tags: packModel.tags,
                      tagsNumber: packModel.tags.length,
                    ),
                  ),
            packModel.description.trim().isEmpty
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 14.0,
                      right: 14.0,
                      top: 8.0,
                      bottom: 16.0,
                    ),
                    child: Text(
                      packModel.description,
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
