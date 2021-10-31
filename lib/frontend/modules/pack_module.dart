import 'dart:io';

import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_storage_api.dart';
import 'package:paclub/backend/api/pack_api.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class PackModule extends GetxController {
  final PackApi _packApi = Get.find<PackApi>();

  // MARK: FirebaseStorageApi
  Future<AppResponse> uploadPackPhoto({
    required File imageFile,
    required String filePath,
  }) async {
    final FirebaseStorageApi _firebaseStorageApi =
        Get.find<FirebaseStorageApi>();

    return _firebaseStorageApi.uploadImage(
        imageFile: imageFile, filePath: 'packPhoto/$filePath');
  }

  Future<AppResponse> uploadPostImage({
    required File imageFile,
    required String filePath,
  }) async {
    final FirebaseStorageApi _firebaseStorageApi =
        Get.find<FirebaseStorageApi>();

    return _firebaseStorageApi.uploadImage(
        imageFile: imageFile, filePath: 'packPhoto/$filePath');
  }

  // MARK: GET 部分
  /// ## NOTE: 获取 Pack 的 Stream
  Stream<List<PackModel>> getPackStream({
    required String uid,
  }) =>
      _packApi.getPackStream(uid: uid);

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
    AppResponse appResponseSetPack =
        await _packApi.setPack(packModel: packModel);
    if (appResponseSetPack.data == null) {
      return appResponseSetPack;
    }
    return appResponseSetPack;
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
