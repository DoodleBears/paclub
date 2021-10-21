import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/user_repository.dart';
import 'package:paclub/models/friend_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class UserApi extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  // MARK: GET 部分
  /// NOTE: 获取用户信息
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [UserModel] 用户信息 | 失败: null
  Future<AppResponse> getUserProfile() async =>
      _userRepository.getUserProfile();

  /// ## NOTE: 获取好友列表（聊天列表）
  /// ## 传入参数
  /// - [uid] 好友 uid
  ///
  /// ## 回传值
  /// - [Stream]
  Stream<List<FriendModel>> getFriendChatroomListStream(
          {required String uid}) =>
      _userRepository.getFriendChatroomListStream(uid: uid);

  /// ## NOTE: 获取未读消息数量
  /// ## 传入参数
  /// - [chatUserUid] 聊天对象 uid
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [int] 未读消息数量 | 失败: null
  Future<AppResponse> getFriendChatroomNotRead(
          {required String chatUserUid}) async =>
      _userRepository.getFriendChatroomNotRead(chatUserUid: chatUserUid);

  /// ## NOTE: 获取用户搜索结果(用于寻找用户-之后可添加好友)
  /// ## 传入参数
  /// - [searchText] 搜索关键字
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [List] List<UserModel>用户列表 | 失败: null
  Future<AppResponse> getUserSearchResult({required String searchText}) async =>
      _userRepository.getUserSearchResult(searchText: searchText);

  // MARK: SET 部分
  /// NOTE: 修改用户头像
  /// ## 传入参数
  /// - [imageFile] 图片源文件
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [String] 图片的URL | 失败: null
  Future<AppResponse> updateUserProfile(
          {required Map<String, dynamic> updateMap}) async =>
      _userRepository.updateUserProfile(
        updateMap: updateMap,
      );
  // MARK: ADD 部分
  /// ## NOTE: 添加新用户（设置信息）
  /// 如果用户登录，则更新上次登录时间
  /// 如果用户首次注册，则添加基础信息到 Firestore
  /// ## 传入参数
  /// - [userModel] 存储用户信息的Model
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [UserModel] 用户信息 | 失败: null
  Future<AppResponse> addUser({required UserModel userModel}) async =>
      _userRepository.addUser(userModel: userModel);

  /// ## NOTE: 加某用户为好友
  /// A 添加 B 为好友，需要在 A 的 firends 里面加入 B
  /// 同样需要在 B 的 friends 里面加入 A
  /// ## 传入参数
  /// - [uid] 用户 A 的 id
  /// - [friendUid] 用户 A 的 id
  /// - [friendName] 用户 B 的 id
  /// - [friendType] 用户 B 的 对于 A 属于什么 Type(什么分组的朋友)
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [UserModel] 用户信息 | 失败: null
  Future<AppResponse> addFriend(
          {required String uid,
          required String friendUid,
          required String friendName,
          String friendType = 'default'}) async =>
      _userRepository.addFriend(
          uid: uid,
          friendUid: friendUid,
          friendName: friendName,
          friendType: friendType);

  // MARK: UPDATE 部分
  /// NOTE: 但有新 message 发送到聊天室时，需要更新更新双方的 messageNotRead 和 lastMessage, lastMessageTime
  /// ## 传入参数
  /// - [message] 消息内容
  /// - [chatWithUserUid] 用户 A 的 UID
  /// - [userUid] 用户 B 的 UID
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [String] 聊天对象的 UID | 失败: null
  Future<AppResponse> updateFriendLastMessage({
    required String message,
    required String userUid,
    required String chatWithUserUid,
  }) async =>
      _userRepository.updateFriendLastMessage(
          message: message, userUid: userUid, chatWithUserUid: chatWithUserUid);

  /// ## NOTE: 进入房间
  /// ## 传入参数
  /// - [friendUid] 聊天对象的 UID
  /// - [isInRoom] 用户是否在聊天室（如果进入聊天室则传入 True, 离开则 False
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [String] 聊天对象的 UID | 失败: null
  Future<AppResponse> updateUserInRoom({
    required String friendUid,
    required bool isInRoom,
  }) async =>
      _userRepository.updateUserInRoom(
          friendUid: friendUid, isInRoom: isInRoom);

  // MARK: 初始化
  @override
  void onInit() {
    logger.i('接入 UserApi');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('断开 UserApi');
    super.onClose();
  }
}
