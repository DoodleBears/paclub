import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:paclub/constants/log_message.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class FirebaseStorageRepository extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// NOTE: 上传图片
  Future<AppResponse> uploadImage({
    required File imageFile,
    required String filePath,
  }) async {
    logger.i('开始上传图像到: $filePath');

    try {
      await _storage.ref(filePath).putFile(imageFile);
      String avatarURL = await _storage.ref(filePath).getDownloadURL();
      logger.i('图像上传成功, URL: $avatarURL');
      return AppResponse(kUploadImageSuccess, avatarURL);
    } on FirebaseException catch (e) {
      logger3.e('上传图像失败, 错误代码: ${e.code}');
      return AppResponse(kUploadImageFailed, null);
    } catch (e) {
      logger3.e('上传图像失败, 错误类型: ${e.runtimeType}');
      return AppResponse(kUploadImageFailed, null);
    }
  }

  // MARK: 初始化
  @override
  void onInit() {
    logger3.i('初始化 FirebaseStorageRepository');
    super.onInit();
  }

  @override
  void onClose() {
    logger3.w('关闭 FirebaseStorageRepository');

    super.onClose();
  }
}
