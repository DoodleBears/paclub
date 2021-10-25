import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_auth_api.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/widgets/notifications/notifications.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/utils/app_response.dart';

/// [认证模块]
class AuthModule extends GetxController {
  final FirebaseAuthApi _firebaseAuthApi = Get.find<FirebaseAuthApi>();

  bool isLogin() {
    return _firebaseAuthApi.isLogin();
  }

  User? get user {
    return _firebaseAuthApi.user;
  }

  void reload() => _firebaseAuthApi.reload();

  Future<AppResponse> registerWithEmail(
      String email, String password, String name, String bio) async {
    return _firebaseAuthApi.registerWithEmail(email, password, name, bio);
  }

  bool isEmailVerified() {
    return _firebaseAuthApi.isEmailVerified();
  }

  Future<AppResponse> sendEmailVerification() async {
    return _firebaseAuthApi.sendEmailVerification();
  }

  Future<AppResponse> signInWithEmailAndPassword(
      String email, String password) async {
    return _firebaseAuthApi.signInWithEmailAndPassword(email, password);
  }

  Future<AppResponse> signInWithGoogle() async {
    return _firebaseAuthApi.signInWithGoogle();
  }

  Future<void> signOut() async {
    AppResponse appResponse = await _firebaseAuthApi.signOut();

    if (appResponse.data != null) {
      Get.until((route) => false); // [清空所有页面] pop all the page in stack
      Get.toNamed(Routes.AUTH); // 跳转到 authentication 页面
    }
    toastTop(appResponse.message);
  }

  @override
  void onInit() {
    logger.i('调用 AuthModule');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('结束调用 AuthModule');
    super.onClose();
  }
}
