import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/widgets/badges/badges.dart';
import 'package:paclub/helper/chatroom_helper.dart';

///此Function為搜尋完畢後的用戶名單頁面
// TODO 头像显示
class ChatroomsListUserTile extends StatelessWidget {
  final String userUid;
  final String userName;
  final String chatroomId;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final int messageNotRead;

  ChatroomsListUserTile(
      {required this.userName,
      required this.chatroomId,
      required this.userUid,
      required this.lastMessage,
      required this.messageNotRead,
      required this.lastMessageTime});

  @override
  Widget build(BuildContext context) {
    ///點擊任一名單上的用戶，都可以進入與該用戶的個人聊天室
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(
          Routes.TABS + Routes.MESSAGE + Routes.CHATROOMLIST + Routes.CHATROOM,
          arguments: {
            'userName': userName,
            'chatroomId': chatroomId,
            'userUid': userUid,
            'messageNotRead': messageNotRead,
          },
        );
        // 离开房间
        final UserModule userModule = Get.find<UserModule>();
        userModule.updateUserInRoom(friendUid: userUid, isInRoom: false);
      },

      ///每位用戶顯示於名單上的UI介面
      child: GetBuilder<AppController>(
        builder: (_) {
          return Container(
            color: AppColors.chatroomTileBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Container(
              height: 60.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // 头像
                  Container(
                    margin: EdgeInsets.only(right: 12.0),
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(userName.substring(0, 1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  // 其他文本内容
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 用户名 username 和 最后消息时间 lastMessageTime
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$userName',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '${chatroomListFormatTime(lastMessageTime)}',
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
                          children: [
                            // 最后消息 lastMessage
                            Expanded(
                              child: Text(
                                lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            // 未读数量 messageNotRead
                            NumberBadge(
                              number: messageNotRead,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
