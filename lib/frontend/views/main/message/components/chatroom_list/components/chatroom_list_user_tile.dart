import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/helper/chatroom_helper.dart';

///此Function為搜尋完畢後的用戶名單頁面
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
        final UserRepository userRepository = Get.find<UserRepository>();
        userRepository.enterLeaveRoom(friendUid: userUid, isEnterRoom: false);
      },

      ///每位用戶顯示於名單上的UI介面
      child: GetBuilder<UserController>(
        builder: (_) {
          return Container(
            color: AppColors.chatroomTileBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 54.0,
                  child: Row(
                    children: [
                      // 头像
                      Container(
                        margin: EdgeInsets.only(right: 12.0),
                        height: 54.0,
                        width: 54.0,
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
                      // 姓名和最后消息时间
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    '$userName',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
                            // 最后消息 和 未读数量
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                // 未读消息
                                Visibility(
                                  visible: messageNotRead != 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      messageNotRead > 99
                                          ? '99+'
                                          : '$messageNotRead',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
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
