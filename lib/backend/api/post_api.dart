import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/post_repository.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class PostApi extends GetxController {
  final PostRepository _postRepository = Get.find<PostRepository>();

  // MARK: GET 部分
  /// ## NOTE: 获取刚新发布的 Post 流 （比当前第一条 Post Feed，更加新的）
  Future<AppResponse> getNewFeedPosts({
    required DocumentSnapshot firstPostDoc,
  }) async =>
      _postRepository.getNewFeedPosts(firstPostDoc: firstPostDoc);

  /// ## NOTE: 第一次获取 Post
  /// ## 传入参数
  /// - [limit] 获取 Pack 数量
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [List] 历史消息 [PostModel] | 失败: null
  Future<AppResponse> getPostsFirstTime({
    int limit = 30,
  }) async =>
      _postRepository.getFeedPosts(
        limit: limit,
        firstTime: true,
      );

  /// ## NOTE: 获取更多 Post
  /// ## 传入参数
  /// - [limit] 获取 Pack 数量
  /// - [lastPostDoc] 最早的历史消息的Doc, 用最早的历史消息作为起点拉取更早的历史消息
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [List] 历史消息 [PostModel] | 失败: null
  Future<AppResponse> getMorePosts({
    int limit = 30,
    required DocumentSnapshot lastPostDoc,
  }) async =>
      _postRepository.getFeedPosts(
        limit: limit,
        firstTime: false,
        lastPostDoc: lastPostDoc,
      );

  // MARK: UPDATE 部分
  /// ## NOTE: 更新 Post
  /// ## 传入参数
  /// - [postId] Post Id
  /// - [updateMap] Pack 更新的 Map - key:value
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [String] Post ID 收纳盒 ID | 失败: null
  Future<AppResponse> updatePost({
    required String postId,
    required Map<String, dynamic> updateMap,
  }) async =>
      _postRepository.updatePost(postId: postId, updateMap: updateMap);

  // MARK: SET 部分
  /// ## NOTE: 创建 Post
  /// ## 传入参数
  /// - [postModel] Post 贴文的信息
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [String] Post ID 收纳盒 ID | 失败: null
  Future<AppResponse> setPost({
    required PostModel postModel,
  }) async =>
      _postRepository.setPost(postModel: postModel);

  // MARK: 初始化
  @override
  void onInit() {
    logger.i('接入 PostApi');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('断开 PostApi');
    super.onClose();
  }
}
