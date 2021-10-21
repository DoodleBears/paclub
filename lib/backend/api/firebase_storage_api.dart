import 'dart:io';

import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/firebase_storage_repository.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class FirebaseStorageApi extends GetxController {
  final FirebaseStorageRepository _firebaseStorageRepository =
      Get.find<FirebaseStorageRepository>();

  Future<AppResponse> uploadImage({
    required File imageFile,
    required String filePath,
  }) async =>
      _firebaseStorageRepository.uploadImage(
          imageFile: imageFile, filePath: filePath);

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
