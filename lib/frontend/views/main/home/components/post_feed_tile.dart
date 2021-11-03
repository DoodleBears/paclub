import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/main/home/components/status_button.dart';
import 'package:paclub/frontend/views/main/home/components/tags_block.dart';
import 'package:paclub/frontend/widgets/avatar/circle_avatar_container.dart';
import 'package:paclub/models/post_model.dart';

class PostFeedTile extends StatelessWidget {
  const PostFeedTile({
    Key? key,
    required this.postModel,
  }) : super(key: key);
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          Colors.grey[300],
        ),
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
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // NOTE: Post 用户头像
                  CircleAvatarContainer(
                    avatarUrl: postModel.ownerAvatarURL,
                    width: 48.0,
                    height: 48.0,
                    replaceWidget: Center(
                      child: Text(
                        postModel.ownerName.substring(0, 1),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                          color: AppColors.normalTextColor,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox.expand(),
                  ),
                  // NOTE: Post Info 信息
                  Expanded(
                    flex: 30,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOTE: Post Title
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            children: [
                              Text(
                                postModel.ownerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.normalTextColor,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    '@' + postModel.ownerUid,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: AppColors.normalGrey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        // NOTE: Post Photos
                        postModel.photoURLs.length == 0
                            ? SizedBox.shrink()
                            : Stack(
                                children: [
                                  Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Ink.image(
                                      image: CachedNetworkImageProvider(
                                        postModel.photoURLs[0],
                                      ),
                                      fit: BoxFit.cover,
                                      height: 300,
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
                        // NOTE: Post Tags
                        postModel.tags.length == 0
                            ? SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TagsBlock(
                                    tags: postModel.tags,
                                    tagsNumber:
                                        postModel.tags.length > 3 ? 3 : postModel.tags.length,
                                    alignment: WrapAlignment.end,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
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
