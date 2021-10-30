import 'package:paclub/frontend/modules/chatroom_module.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/utils/gesture.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
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

  UserModule userModule = Get.find<UserModule>();
  ChatroomModule chatroomModule = Get.find<ChatroomModule>();

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

  void searchByName(BuildContext context) async {
    hideKeyboard(context);
    searchText = searchTextController.text;
    if (searchText.isNotEmpty && isLoading == false) {
      // 告诉用户，开始加载搜索结果
      logger.d('开始搜索: ' + searchText);
      isLoading = true;
      update();

      // 开始搜索
      AppResponse appResponse =
          await userModule.getUserSearchResult(searchText: searchText);
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
      {required String userName,
      required String userUid,
      required String avatarURL,
      required bool isChatroomExist,
      required int index}) async {
    if (isChatroomExist) {
      logger.w('聊天室已存在');
      return AppResponse('chatroom_already_exist', null);
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
    );
    // NOTE: 添加 聊天室
    AppResponse appResponseChatroom =
        await chatroomModule.addChatroom(chatroomModel: chatroomModel);
    isAddUserLoading[index] = false;
    update();
    // 如果添加 chatroom 失败, return
    if (appResponseChatroom.data == null) {
      toastBottom('failed to add Chatroom');
      return AppResponse(appResponseChatroom.message, null);
    }

    // NOTE: AB加好友，添加 B 到 A 的好友列表
    AppResponse appResponseUser1 = await userModule.addFriend(
      chatroomId: appResponseChatroom.data, // data 是 chatroomId
      uid: chatroomModel.users[0],
      friendUid: chatroomModel.users[1],
      friendName: chatroomModel.usersName['${chatroomModel.users[1]}'],
    );
    // NOTE: AB加好友，添加 A 到 B 的好友列表
    AppResponse appResponseUser2 = await userModule.addFriend(
      chatroomId: appResponseChatroom.data, // data 是 chatroomId
      uid: chatroomModel.users[1],
      friendUid: chatroomModel.users[0],
      friendName: chatroomModel.usersName['${chatroomModel.users[0]}'],
    );
    if (appResponseUser1.data == null) {
      toastBottom('failed to add Friend');
      return AppResponse(appResponseUser1.message, null);
    } else if (appResponseUser2.data == null) {
      toastBottom('failed to add Friend');
      return AppResponse(appResponseUser2.message, null);
    } else {
      logger.d(appResponseChatroom.message);
      Map<String, dynamic> chatroomInfo = {
        "userUid": userUid,
        "userName": userName,
        "chatroomId": appResponseChatroom.data,
        "avatarURL": avatarURL,
      };
      return AppResponse(appResponseChatroom.message, chatroomInfo);
    }
  }
}
