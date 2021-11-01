import 'dart:io';

import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/firebase_storage_repository.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class FirebaseStorageApi extends GetxController {
  final FirebaseStorageRepository _firebaseStorageRepository =
      Get.find<FirebaseStorageRepository>();

  /// ## NOTE: 上传图像到 Firebase Storage
  /// ## 传入参数
  /// - [imageFile] 图像 File
  /// - [filePath]] 图像存放的路径 Path
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [String] 图像在 Firebase Storage 的链接 | 失败: null
  Future<AppResponse> uploadImage({
    required File imageFile,
    required String filePath,
  }) async =>
      _firebaseStorageRepository.uploadImage(imageFile: imageFile, filePath: filePath);

  @override
  void onInit() {
    logger.i('接入 FirebaseStorageApi');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('断开 FirebaseStorageApi');
    super.onClose();
  }
}
