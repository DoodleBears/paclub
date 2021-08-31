import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_controller.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/components/search_user_tile.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_controller.dart';
import 'package:paclub/helper/constants.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSearchBody extends GetView<UserSearchController> {
  final ChatroomListController chatroomListController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Expanded(
              child: TextField(
                controller: controller.searchTextController,
                style: TextStyle(color: Colors.white, fontSize: 18),
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
                        primary: accentDarkColor,
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
          ),
          GetBuilder<UserSearchController>(
            builder: (_) {
              // 获取 聊天室 的用户列表，排除已有聊天室
              // TODO 将判断改为聊天室 id 比对
              List<String> chatroomIdList = chatroomListController
                  .chatroomStream
                  .map((ChatroomModel chatroomModel) => chatroomModel.chatroomId
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, ""))
                  .toList();
              logger.d(chatroomIdList);
              return controller.isLoading
                  ? Expanded(
                      child: Center(
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    )
                  : controller.haveUserSearched
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.userList.length,
                          itemBuilder: (context, index) {
                            return SearchUserTile(
                              isChatroomExist: chatroomIdList.contains(
                                  controller.userList[index].displayName),
                              userName: controller.userList[index].displayName,
                              userEmail: controller.userList[index].email,
                            );
                          })
                      : SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
