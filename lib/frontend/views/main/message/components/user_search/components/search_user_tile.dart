import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/app_response.dart';

class SearchUserTile extends GetView<UserSearchController> {
  final bool isChatroomExist;
  final String userName;
  final String userEmail;

  const SearchUserTile(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.isChatroomExist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              primary: accentColor,
              shape: StadiumBorder(),
            ),
            onPressed: () async {
              AppResponse appResponse =
                  await controller.addFriend(userName, isChatroomExist);
              if (appResponse.data != null) {
                Map<String, dynamic> chatroomInfo = appResponse.data;
                Get.toNamed(
                    Routes.TABS +
                        Routes.MESSAGE +
                        Routes.CHATROOMLIST +
                        Routes.CHATROOM,
                    arguments: chatroomInfo);
              }
            },
            child: FittedBox(
              child: GetBuilder<UserSearchController>(
                builder: (_) {
                  return controller.isAddUserLoading
                      ? CircularProgressIndicator()
                      : Text(
                          isChatroomExist ? "Message" : 'Add Friend',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
