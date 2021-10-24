import 'package:cached_network_image/cached_network_image.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/views/auth/login/components/components.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/app_response.dart';

class SearchUserTile extends GetView<UserSearchController> {
  final int index;
  final bool isChatroomExist;
  final String userAvatarURL;
  final String userUid;
  final String userName;
  final String userBio;

  const SearchUserTile({
    Key? key,
    required this.userAvatarURL,
    required this.index,
    required this.isChatroomExist,
    required this.userUid,
    required this.userName,
    required this.userBio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      Get.toNamed(
        Routes.TABS + Routes.OTHERUSER,
        parameters: {'uid': userUid},
        arguments: {
          'userName': userName,
          'avatarURL': userAvatarURL,
        },
      );
    }, child: GetBuilder<AppController>(
      builder: (_) {
        return Container(
          color: AppColors.chatroomTileBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              ClipOval(
                child: Material(
                  color: AppColors.chatAvatarBackgroundColor,
                  child: userAvatarURL == ''
                      ? Container(
                          width: 60.0,
                          height: 60.0,
                          child: Center(
                            child: Text(userName.substring(0, 1).toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      : Ink.image(
                          image: CachedNetworkImageProvider(userAvatarURL),
                          fit: BoxFit.cover,
                          width: 60.0,
                          height: 60.0,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      userBio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: GetBuilder<UserSearchController>(
                  builder: (_) {
                    return RoundedLoadingButton(
                      loadingWidget: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          // 设置为白色（保持不变的 Animation，一直为白色
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          // 进度条背后背景的颜色（圆圈底下的部分）
                          // backgroundColor: Colors.grey[300],
                          strokeWidth: 5.0,
                        ),
                      ),
                      onPressed: () async {
                        if (controller.isAddUserLoading.contains(true)) {
                          return; //防止频繁和列表交互
                        }
                        AppResponse appResponse = await controller.addFriend(
                          userName: userName,
                          userUid: userUid,
                          avatarURL: userAvatarURL,
                          isChatroomExist: isChatroomExist,
                          index: index,
                        );
                        if (appResponse.data != null) {
                          Map<String, dynamic> chatroomInfo = appResponse.data;
                          await Get.toNamed(
                              Routes.TABS +
                                  Routes.MESSAGE +
                                  Routes.CHATROOMLIST +
                                  Routes.CHATROOM,
                              arguments: chatroomInfo);
                          // 离开房间
                          final UserModule userModule = Get.find<UserModule>();
                          userModule.updateUserInRoom(
                              friendUid: userUid, isInRoom: false);
                        }
                      },
                      height: 44.0,
                      width: 160.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      text: isChatroomExist ? "Message" : 'Add Friend',
                      color: accentColor,
                      isLoading: controller.isAddUserLoading[index],
                      shape: StadiumBorder(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
