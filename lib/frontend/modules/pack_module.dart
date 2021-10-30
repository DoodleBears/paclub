import 'dart:io';

import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_storage_api.dart';
import 'package:paclub/backend/api/pack_api.dart';
import 'package:paclub/constants/log_message.dart';
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
    File? imageFile,
  }) async {
    AppResponse appResponseSetPack =
        await _packApi.setPack(packModel: packModel);
    if (appResponseSetPack.data == null) {
      return appResponseSetPack;
    }
    // NOTE: 如果用户有设定 Pack 头图, 则上传头图
    if (imageFile != null) {
      AppResponse appResponseUploadPackPhoto = await uploadPackPhoto(
          imageFile: imageFile, filePath: appResponseSetPack.data);
      // NOTE: 成功上传 Pack 头图
      if (appResponseUploadPackPhoto.data != null) {
        AppResponse appResponseUpdatePack = await _packApi.updatePack(
          pid: appResponseSetPack.data,
          updateMap: {
            'photoURL': appResponseUploadPackPhoto.data,
          },
        );
        if (appResponseUpdatePack.data != null) {
          return appResponseSetPack;
        } else {
          logger3.e(appResponseUpdatePack);
          return appResponseUpdatePack;
        }
      } else {
        // NOTE: 成功上传 Pack 头图
        return AppResponse(kUploadImageFailed, null);
      }
    } else {
      // NOTE: 用户没有设定 Pack 头图, 直接回传
      return appResponseSetPack;
    }
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
