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
          GetBuilder<UserSearchController>(
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
                width: 110.0,
                height: 40.0,
                text: isChatroomExist ? "Message" : 'Add Friend',
                color: accentColor,
                isLoading: controller.isAddUserLoading,
                shape: StadiumBorder(),
              );
            },
          ),
        ],
      ),
    );
  }
}
