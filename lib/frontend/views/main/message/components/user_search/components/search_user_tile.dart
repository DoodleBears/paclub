import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/views/auth/login/components/components.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/app_response.dart';

class SearchUserTile extends GetView<UserSearchController> {
  final int index;
  final bool isChatroomExist;
  final String userUid;
  final String userName;
  final String userEmail;

  const SearchUserTile({
    Key? key,
    required this.index,
    required this.isChatroomExist,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            height: 48.0,
            width: 48.0,
            decoration: BoxDecoration(
                color: accentColor, borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300)),
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
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 16),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                        userName, userUid, isChatroomExist, index);
                    if (appResponse.data != null) {
                      Map<String, dynamic> chatroomInfo = appResponse.data;
                      await Get.toNamed(
                          Routes.TABS +
                              Routes.MESSAGE +
                              Routes.CHATROOMLIST +
                              Routes.CHATROOM,
                          arguments: chatroomInfo);
                      // 离开房间
                      final UserRepository userRepository =
                          Get.find<UserRepository>();
                      userRepository.enterLeaveRoom(
                          friendUid: userUid, isEnterRoom: false);
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
  }
}
