import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/main/home/components/status_button.dart';
import 'package:paclub/frontend/views/main/home/components/tags_block.dart';
import 'package:paclub/frontend/widgets/avatar/circle_avatar_container.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/r.dart';

class PackFeedTile extends StatelessWidget {
  const PackFeedTile({
    Key? key,
    required this.packModel,
  }) : super(key: key);
  final PackModel packModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: primaryLightColor.withAlpha(64),
          ),
          padding: const EdgeInsets.all(12.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // NOTE: Pack Icon
                Flexible(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: packModel.photoURL == ''
                        ? Image.asset(R.appIcon)
                        : Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Ink.image(
                              image: CachedNetworkImageProvider(
                                packModel.photoURL,
                              ),
                              fit: BoxFit.cover,
                              height: 58.0,
                              width: 58.0,
                            ),
                          ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox.expand(),
                ),
                // NOTE: Pack Info 信息
                Expanded(
                  flex: 30,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOTE: Pack Name
                      Text(
                        packModel.packName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: AppColors.normalTextColor,
                        ),
                      ),
                      // NOTE: Pack Owner Avatar and Name
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Row(
                          children: [
                            CircleAvatarContainer(
                              avatarUrl: packModel.ownerAvatarURL,
                              width: 24.0,
                              height: 24.0,
                              replaceWidget: Center(
                                child: Text(
                                  packModel.ownerName.substring(0, 1),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.0,
                                    color: AppColors.normalTextColor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  packModel.ownerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.normalTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // NOTE: Pack Tags
                      TagsBlock(tags: packModel.tags),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // verticalDirection: VerticalDirection.up,
          children: [
            SizedBox(width: 100.0),
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
                color: Colors.red,
                size: 22.0,
              ),
              number: packModel.thumbUpCount,
            ),
          ],
        )
      ],
    );
  }
}
