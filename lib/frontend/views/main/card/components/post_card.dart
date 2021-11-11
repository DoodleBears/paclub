import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/home/components/tags_block.dart';
import 'package:paclub/frontend/widgets/avatar/circle_avatar_container.dart';
import 'package:paclub/models/post_model.dart';
// FIXME: 修复排版样式

class PostCard extends StatelessWidget {
  final PostModel postModel;
  final double height;

  const PostCard({
    Key? key,
    required this.postModel,
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
                        CircleAvatarContainer(
                          avatarUrl: postModel.ownerAvatarURL,
                          width: 36.0,
                          height: 36.0,
                          replaceWidget: Center(
                            child: Text(
                              postModel.ownerName.substring(0, 1),
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
            Stack(
              children: [
                postModel.photoURLs.length == 0
                    ? SizedBox.shrink()
                    : Container(
                        width: 400,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(
                          postModel.photoURLs[0],
                          fit: BoxFit.cover,
                        ),
                      ),
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
                              avatarUrl: postModel.ownerAvatarURL,
                              width: 36.0,
                              height: 36.0,
                              replaceWidget: Center(
                                child: Text(
                                  postModel.ownerName.substring(0, 1),
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
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Text(
                      postModel.content,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
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
