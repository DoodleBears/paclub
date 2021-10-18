import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_controller.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/components/search_user_tile.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_controller.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO 好友申请功能
class UserSearchBody extends GetView<UserSearchController> {
  final ChatroomListController chatroomListController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: controller.searchTextController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: "search username ...",
                hintStyle: TextStyle(
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: accentDarkColor),
                ),
                suffixIcon: Container(
                  width: 60.0,
                  padding: EdgeInsets.fromLTRB(0, 0, 7.0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(8.0),
                      primary: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                    onPressed: () async => controller.searchByName(),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<ChatroomListController>(
              builder: (_) {
                return GetBuilder<UserSearchController>(
                  builder: (_) {
                    List<String> chatroomIdList = chatroomListController
                        .friendsStream
                        .map((FriendModel friendModel) => friendModel.friendUid)
                        .toList();
                    logger.d(chatroomIdList);
                    return controller.isLoading
                        ? Center(
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.userList.length,
                            itemBuilder: (context, index) {
                              final UserModel userModel =
                                  controller.userList[index];
                              return GestureDetector(
                                child: SearchUserTile(
                                  index: index,
                                  isChatroomExist:
                                      chatroomIdList.contains(userModel.uid),
                                  userUid: userModel.uid,
                                  userName: userModel.displayName,
                                  userEmail: userModel.email,
                                ),
                              );
                            },
                          );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
