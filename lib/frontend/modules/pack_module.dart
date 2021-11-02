import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_storage_api.dart';
import 'package:paclub/backend/api/pack_api.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class PackModule extends GetxController {
  final PackApi _packApi = Get.find<PackApi>();

  // MARK: GET 部分
  /// ## NOTE: 获取刚新发布的 Pack 流
  /// ## 传入参数
  /// - [firstPackDoc] 当前第一条 Pack Feed
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [List] 历史消息 [PackModel] | 失败: null
  Future<AppResponse> getNewFeedPacks({
    required DocumentSnapshot firstPackDoc,
  }) async =>
      _packApi.getNewFeedPacks(firstPackDoc: firstPackDoc);

  /// ## NOTE: 获取 Pack 的 Stream
  Stream<List<PackModel>> getPackStream({
    required String uid,
  }) =>
      _packApi.getPackStream(uid: uid);

  /// ## NOTE: 第一次获取 Pack
  Future<AppResponse> getPacksFirstTime({
    int limit = 30,
  }) async =>
      _packApi.getPacksFirstTime(
        limit: limit,
      );

  /// ## NOTE: 第一次获取 Pack
  Future<AppResponse> getMorePacks({
    int limit = 30,
    required DocumentSnapshot lastPackDoc,
  }) async =>
      _packApi.getMorePacks(
        limit: limit,
        lastPackDoc: lastPackDoc,
      );

  // MARK: UPDATE 部分
  /// ## NOTE: 更新 Pack 收纳盒
  Future<AppResponse> updatePack({
    required String pid,
    required Map<String, dynamic> updateMap,
  }) async =>
      _packApi.updatePack(pid: pid, updateMap: updateMap);

  // MARK: SET 部分
  Future<AppResponse> setPack({
    required PackModel packModel,
  }) async {
    AppResponse appResponseSetPack = await _packApi.setPack(packModel: packModel);
    if (appResponseSetPack.data == null) {
      return appResponseSetPack;
    }
    return appResponseSetPack;
  }

  // MARK: FirebaseStorageApi
  Future<AppResponse> uploadPackPhoto({
    required File imageFile,
    required String filePath,
  }) async {
    final FirebaseStorageApi _firebaseStorageApi = Get.find<FirebaseStorageApi>();

    return _firebaseStorageApi.uploadImage(imageFile: imageFile, filePath: 'packPhoto/$filePath');
  }

  // MARK: 初始化
  @override
  void onInit() {
    logger.i('调用 PackModule');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('结束调用 PackModule');
    super.onClose();
  }
}
