import 'dart:io';
import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_storage_api.dart';
import 'package:paclub/backend/api/post_api.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class PostModule extends GetxController {
  final PostApi _postApi = Get.find<PostApi>(); // 用于创建 Post

  // MARK: FirebaseStorageApi
  /// ## NOTE: 上传 Post 的图像
  Future<AppResponse> uploadPostImage({
    required File imageFile,
    required String postId,
    required int imageIndex,
  }) async {
    final FirebaseStorageApi _firebaseStorageApi = Get.find<FirebaseStorageApi>();

    return _firebaseStorageApi.uploadImage(
        imageFile: imageFile, filePath: 'postImage/$postId/$imageIndex');
  }

  // MARK: GET 部分
  /// ## NOTE: 获取 Post 的 Stream

  // MARK: UPDATE 部分
  /// ## NOTE: 更新 Post
  Future<AppResponse> updatePost({
    required String postId,
    required Map<String, dynamic> updateMap,
  }) async =>
      _postApi.updatePost(postId: postId, updateMap: updateMap);

  // MARK: SET 部分
  /// ## NOTE: 创建 Post
  Future<AppResponse> setPost({
    required PostModel postModel,
  }) async {
    return _postApi.setPost(postModel: postModel);
  }

  // MARK: 初始化
  @override
  void onInit() {
    logger.i('调用 PostModule');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('结束调用 PostModule');
    super.onClose();
  }
}
