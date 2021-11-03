import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/main/home/components/status_button.dart';
import 'package:paclub/frontend/views/main/home/components/tags_block.dart';
import 'package:paclub/frontend/widgets/avatar/circle_avatar_container.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/r.dart';

class PackCard extends StatelessWidget {
  final PackModel packModel;
  final double height;
  const PackCard({
    Key? key,
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
                        CircleAvatarContainer(
                          avatarUrl: packModel.ownerAvatarURL,
                          width: 36.0,
                          height: 36.0,
                          replaceWidget: Center(
                            child: Text(
                              packModel.ownerName.substring(0, 1),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24.0,
                                color: AppColors.normalTextColor,
                              ),
                            ),
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
                      maxLines: 2, //最多顯示行數
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            // NOTE: Pack If have Image
            Stack(
              children: [
                packModel.photoURL == ''
                    ? SizedBox.shrink()
                    : Container(
                        width: 400,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(
                          packModel.photoURL,
                          fit: BoxFit.cover,
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
                            CircleAvatarContainer(
                              avatarUrl: packModel.ownerAvatarURL,
                              width: 36.0,
                              height: 36.0,
                              replaceWidget: Center(
                                child: Text(
                                  packModel.ownerName.substring(0, 1),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.0,
                                    color: AppColors.normalTextColor,
                                  ),
                                ),
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
            Padding(
              //上下左右各添加16像素补白
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: TagsBlock(
                alignment: packModel.photoURL == '' ? WrapAlignment.center : WrapAlignment.start,
                fontSize: 18.0,
                spacing: 2.0,
                runSpacing: 2.0,
                tags: packModel.tags,
                tagsNumber: packModel.tags.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              child: Text(
                packModel.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0, //描述內容，故字體較小
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
