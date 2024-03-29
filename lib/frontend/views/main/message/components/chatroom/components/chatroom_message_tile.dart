import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/helper/chatroom_helper.dart';

class ChatroomMessageTile extends StatelessWidget {
  final FocusNode focusNode = FocusNode();

  ///當資料傳送到聊天室後，要依照時間先後依序排列，並區分資料傳送端(右側)及接收端(左側)
  final String friendUid;
  final String friendAvatarURL;
  final String senderName;
  final Timestamp sendTime;
  final String message;
  final bool isAvatarShow;
  final bool sendByMe;
  ChatroomMessageTile({
    Key? key,
    required this.message,
    required this.sendByMe,
    required this.senderName,
    required this.sendTime,
    required this.friendAvatarURL,
    required this.friendUid,
    required this.isAvatarShow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: sendByMe ? 20.0 : 12.0,
        right: sendByMe ? 12.0 : 20.0,
        bottom: 4.0,
        top: isAvatarShow ? 8.0 : 0.0,
      ),
      child: Align(
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOTE: 头像
            sendByMe
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      right: 8.0,
                    ),
                    child: isAvatarShow
                        ? GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.TABS + Routes.USER + friendUid,
                                arguments: {
                                  'userName': senderName,
                                  'avatarURL': friendAvatarURL,
                                },
                              );
                            },
                            child: ClipOval(
                              child: Material(
                                color: primaryColor,
                                child: friendAvatarURL == ''
                                    ? Container(
                                        width: 40.0,
                                        height: 40.0,
                                        child: Center(
                                          child: Text(
                                            senderName
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Ink.image(
                                        image: CachedNetworkImageProvider(
                                            friendAvatarURL),
                                        fit: BoxFit.cover,
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 40.0,
                            height: 40.0,
                          ),
                  ),
            // NOTE: 消息内容
            Expanded(
              child: Row(
                textDirection: sendByMe ? TextDirection.rtl : TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 10,
                    child: GestureDetector(
                      onLongPress: () {
                        focusNode.requestFocus();
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: sendByMe
                              ? AppColors.chatroomMyMessageBackgroundColor
                              : AppColors.chatroomOtherMessageBackgroundColor,
                        ),
                        child: SelectableText(
                          message,
                          focusNode: focusNode,
                          cursorColor: primaryColor,

                          toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                          ),
                          // line-height = fontSize * (leading + height) = 16.0 * 1.1 = 17.6
                          strutStyle: StrutStyle(
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  isAvatarShow
                      ? Container(
                          margin: EdgeInsets.only(
                            bottom: 4.0,
                            left: sendByMe ? 0.0 : 4.0,
                            right: sendByMe ? 4.0 : 0.0,
                          ),
                          child: Text(
                            chatMessageformatTime(sendTime),
                            strutStyle: StrutStyle(
                              height: 1,
                              leading: 0.1,
                              fontSize: 10.0,
                            ),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppColors.chatroomMessageTimestampColor,
                              fontSize: 10.0,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: Get.width * 0.1,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
