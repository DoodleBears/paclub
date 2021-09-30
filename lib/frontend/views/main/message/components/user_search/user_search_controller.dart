import 'package:paclub/backend/repository/remote/chatroom_repository.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/helper/chatroom_helper.dart';
import 'package:paclub/models/chatroom_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSearchController extends GetxController {
  String searchText = '';
  bool isLoading = false;
  List<bool> isAddUserLoading = [false];
  bool haveUserSearched = false;
  List<UserModel> userList = List<UserModel>.empty();
  TextEditingController searchTextController = TextEditingController();

  UserRepository userRepository = Get.find<UserRepository>();
  ChatroomRepository chatroomRepository = Get.find<ChatroomRepository>();

  @override
  void onInit() {
    logger.i('启用 UserSearchController');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 UserSearchController');
    super.onClose();
  }

  void searchByName() async {
    searchText = searchTextController.text;
    if (searchText.isNotEmpty && isLoading == false) {
      // 告诉用户，开始加载搜索结果
      logger.d('开始搜索: ' + searchText);
      isLoading = true;
      update();

      // 开始搜索
      AppResponse appResponse = await userRepository.searchByName(searchText);
      logger.d(appResponse.message);
      if (appResponse.data != null) {
        userList = List<UserModel>.from(appResponse.data);
        logger.d('搜索列表长度: ${userList.length}');
        isAddUserLoading = List.filled(userList.length, false);
      }

      logger.d('搜索结束');

      isLoading = false;
      haveUserSearched = true;
      update();
    }
  }

  /// 添加好友（聊天室）
  Future<AppResponse> addFriend(
      String userName, String userUid, bool isChatroomExist, int index) async {
    String chatroomId = getChatRoomId(AppConstants.uuid, userUid);
    Map<String, dynamic> chatroomInfo = {
      "userUid": userUid,
      "userName": userName,
      "chatroomId": chatroomId,
    };
    if (isChatroomExist) {
      logger.w('聊天室已存在');
      return AppResponse('chatroom_already_exist', chatroomInfo);
    }

    isAddUserLoading[index] = true;
    update();
    // 创建 user 列表，存储聊天室的用户列表

    Map<String, dynamic> userNameMap = Map();
    userNameMap[AppConstants.uuid] = AppConstants.userName;
    userNameMap[userUid] = userName;
    ChatroomModel chatroomModel = ChatroomModel(
        users: [AppConstants.uuid, userUid],
        usersName: userNameMap,
        chatroomId: chatroomId);

    AppResponse appResponse = await chatroomRepository.addChatRoom(
      chatroomModel,
      chatroomId,
    );
    isAddUserLoading[index] = false;
    update();
    logger.d(appResponse.message);
    if (appResponse.data == null) {
      toastBottom('failed to add user');
      return AppResponse(appResponse.message, null);
    } else {
      return AppResponse(appResponse.message, chatroomInfo);
    }
  }
}
