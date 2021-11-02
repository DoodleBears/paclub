import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_storage_api.dart';
import 'package:paclub/backend/api/pack_api.dart';
import 'package:paclub/backend/api/post_api.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class PostModule extends GetxController {
  final PostApi _postApi = Get.find<PostApi>(); // 用于创建 Post

  // MARK: GET 部分
  /// ## NOTE: 获取刚新发布的 Post 流 （比当前第一条 Post Feed，更加新的）
  Future<AppResponse> getNewFeedPosts({
    required DocumentSnapshot firstPostDoc,
  }) async =>
      _postApi.getNewFeedPosts(firstPostDoc: firstPostDoc);

  /// ## NOTE: 第一次获取 Post
  Future<AppResponse> getPostsFirstTime({
    int limit = 30,
  }) async =>
      _postApi.getPostsFirstTime(
        limit: limit,
      );

  /// ## NOTE: 获取更多 Post
  Future<AppResponse> getMorePosts({
    int limit = 30,
    required DocumentSnapshot lastPostDoc,
  }) async =>
      _postApi.getMorePosts(
        limit: limit,
        lastPostDoc: lastPostDoc,
      );

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
    AppResponse appResponseSetPost = await _postApi.setPost(postModel: postModel);
    // TODO: 更新 Pack lastUpdateAt

    final PackApi _packApi = Get.find<PackApi>();
    bool isUploadSuccess = true;
    List<Future<AppResponse>> processes = [];
    for (int index = 0; index < postModel.belongPids.length; index++) {
      var uploadProcess = _packApi.updatePack(
        pid: postModel.belongPids[index],
        updateMap: {'lastUpdateAt': FieldValue.serverTimestamp()},
      );
      processes.add(uploadProcess);
    }
    late AppResponse failResponse;
    for (int index = 0; index < postModel.belongPids.length; index++) {
      AppResponse appResponse = await processes[index];
      if (appResponse.data == null) {
        isUploadSuccess = false;
        failResponse = appResponse;
      }
    }

    if (isUploadSuccess) {
      return appResponseSetPost;
    } else {
      return failResponse;
    }
  }

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
