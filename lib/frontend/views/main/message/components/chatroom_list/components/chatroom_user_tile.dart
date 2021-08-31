import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///此Function為搜尋完畢後的用戶名單頁面
class ChatroomsUserTile extends StatelessWidget {
  final String userName;
  final String chatroomId;

  ChatroomsUserTile({required this.userName, required this.chatroomId});

  @override
  Widget build(BuildContext context) {
    ///點擊任一名單上的用戶，都可以進入與該用戶的個人聊天室
    return GestureDetector(
      onTap: () {
        Get.toNamed(
            Routes.TABS +
                Routes.MESSAGE +
                Routes.CHATROOMLIST +
                Routes.CHATROOM,
            arguments: {
              'userName': userName,
              'chatroomId': chatroomId,
            });
      },

      ///每位用戶顯示於名單上的UI介面
      child: Container(
        margin: EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: primaryLightColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 36.0,
                  width: 36.0,
                  decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(userName.substring(0, 1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                const SizedBox(width: 12),
                Text(userName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
