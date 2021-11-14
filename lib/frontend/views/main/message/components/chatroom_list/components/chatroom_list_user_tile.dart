import 'package:cached_network_image/cached_network_image.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_controller.dart';
import 'package:paclub/frontend/widgets/badges/badges.dart';
import 'package:paclub/helper/chatroom_helper.dart';
import 'package:paclub/models/friend_model.dart';

class ChatroomsListUserTile extends GetView<ChatroomListController> {
  final FriendModel friendModel;

  ChatroomsListUserTile({
    required this.friendModel,
  });

  @override
  Widget build(BuildContext context) {
    ///點擊任一名單上的用戶，都可以進入與該用戶的個人聊天室
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(
          Routes.TABS + Routes.MESSAGE + Routes.CHATROOMLIST + Routes.CHATROOM,
          arguments: {
            'userName': friendModel.friendName,
            'chatroomId': friendModel.chatroomId,
            'userUid': friendModel.friendUid,
            'messageNotRead': friendModel.messageNotRead,
            'avatarURL': friendModel.avatarURL,
          },
        );
        // 离开房间
        final UserModule userModule = Get.find<UserModule>();
        userModule.leaveUserRoom(friendUid: friendModel.friendUid);
      },

      ///每位用戶顯示於名單上的UI介面
      child: GetBuilder<AppController>(
        builder: (_) {
          return Container(
            color: AppColors.chatroomTileBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 头像
                Container(
                  margin: EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.TABS + Routes.USER + friendModel.friendUid,
                        arguments: {
                          'userName': friendModel.friendName,
                          'avatarURL': friendModel.avatarURL,
                        },
                      );
                    },
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      color: AppColors.chatAvatarBackgroundColor,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 54.0,
                        height: 54.0,
                        maxWidthDiskCache: 192,
                        memCacheWidth: 128,
                        imageUrl: friendModel.avatarURL,
                        cacheKey: friendModel.avatarURL,
                        errorWidget: (context, url, error) {
                          // FIXME: 当头像没正确加载的时候，
                          controller.updateFriendProfile(friendModel: friendModel);
                          return Center(
                            child: Text(
                              friendModel.friendName.substring(0, 1).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
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
                // 其他文本内容
                Expanded(
                  child: Column(
                    children: [
                      // 用户名 username 和 最后消息时间 lastMessageTime
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${friendModel.friendName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '${chatroomListFormatTime(friendModel.lastMessageTime)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      // 最后消息 lastMessage 和 未读数量 messageNotRead
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // 最后消息 lastMessage
                          Expanded(
                            child: Text(
                              friendModel.lastMessage,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.normalGrey,
                              ),
                            ),
                          ),
                          // 未读数量 messageNotRead
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: NumberBadge(
                              number: friendModel.messageNotRead,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
