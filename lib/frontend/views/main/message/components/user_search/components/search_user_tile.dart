import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/views/login/components/components.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/app_response.dart';

class SearchUserTile extends GetView<UserSearchController> {
  final bool isChatroomExist;
  final String userUid;
  final String userName;
  final String userEmail;

  const SearchUserTile({
    Key? key,
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
                      fontFamily: 'OverpassRegular',
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
          Flexible(
            flex: 10,
            child: GetBuilder<UserSearchController>(
              builder: (_) {
                return RoundedLoadingButton(
                  onPressed: () async {
                    if (controller.isAddUserLoading) {
                      return;
                    }
                    AppResponse appResponse = await controller.addFriend(
                        userName, userUid, isChatroomExist);
                    if (appResponse.data != null) {
                      Map<String, dynamic> chatroomInfo = appResponse.data;
                      Get.offAndToNamed(
                          Routes.TABS +
                              Routes.MESSAGE +
                              Routes.CHATROOMLIST +
                              Routes.CHATROOM,
                          arguments: chatroomInfo);
                    }
                  },
                  width: 120.0,
                  height: 44.0,
                  text: isChatroomExist ? "Message" : 'Add Friend',
                  color: accentColor,
                  isLoading: controller.isAddUserLoading,
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
