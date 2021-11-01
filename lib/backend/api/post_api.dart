import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/post_repository.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class PostApi extends GetxController {
  final PostRepository _postRepository = Get.find<PostRepository>();

  // MARK: GET 部分
  /// ## NOTE: 获取 Post 的 Stream

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
