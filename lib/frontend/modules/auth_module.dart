import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/api/firebase_auth_api.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/widgets/notifications/notifications.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/utils/app_response.dart';

/// [认证模块]
class AuthModule extends GetxController {
  final FirebaseAuthApi _authApi = Get.find<FirebaseAuthApi>();

  bool isLogin() {
    return _authApi.isLogin();
  }

  User? get user {
    return _authApi.user;
  }

  void reload() => _authApi.reload();

  Future<AppResponse> registerWithEmail(
      String email, String password, String name, String bio) async {
    return _authApi.registerWithEmail(email, password, name, bio);
  }

  bool isEmailVerified() {
    return _authApi.isEmailVerified();
  }

  Future<AppResponse> sendEmailVerification() async {
    return _authApi.sendEmailVerification();
  }

  Future<AppResponse> signInWithEmail(String email, String password) async {
    return _authApi.signInWithEmail(email, password);
  }

  Future<AppResponse> signInWithGoogle() async {
    return _authApi.signInWithGoogle();
  }

  Future<void> signOut() async {
    AppResponse appResponse = await _authApi.signOut();

    if (appResponse.data != null) {
      Get.until((route) => false); // [清空所有页面] pop all the page in stack
      Get.toNamed(Routes.AUTH); // 跳转到 authentication 页面
    }
    toastBottom(appResponse.message);
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
