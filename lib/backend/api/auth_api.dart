import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/firebase_auth_repository.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/utils/app_response.dart';

class AuthApi extends GetxController {
  // 依赖于 FirebaseAuthRepository，所以不能是 static function
  // 在这里我们选择API要接入的实际操作后端（有SQL代码）的Repository，调用其function
  // API 对 Repository 是一对多的关系（同理 Module 对 API 也是一对多）
  final FirebaseAuthRepository firebaseAuthRepository =
      Get.find<FirebaseAuthRepository>();

  /// [取得用户类]
  ///
  /// [回传值]
  /// 已登陆: [User] | 未登录: null
  User? get user {
    return firebaseAuthRepository.user;
  }

  /// [重载用户] 当用户登陆或切换状态时候需要用到
  void reload() {
    firebaseAuthRepository.reload();
  }

  /// [检测是否登陆]
  ///
  /// [回传值]
  /// - 已登陆: [bool]true | 未登录&未验证邮箱: [bool]false
  bool isLogin() => firebaseAuthRepository.isLogin();

  /// [Email 注册功能]
  ///
  /// [传入参数]
  /// - [email] 注册邮箱
  /// - [password] 密码
  /// - [name] 用户名
  ///
  /// [回传值]
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [String]email | 失败: null
  Future<AppResponse> registerWithEmail(
          String email, String password, String name) async =>
      firebaseAuthRepository.registerWithEmail(email, password, name);

  /// [发送认证 Email]
  ///
  /// [回传值]
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [bool]true | 失败: null
  Future<AppResponse> sendEmailVerification() async =>
      firebaseAuthRepository.sendEmailVerification();

  /// [检查用户 Email 认证]
  /// - @return: [bool] 成功: true | 失败: false
  bool isEmailVerified() {
    return firebaseAuthRepository.isEmailVerified();
  }

  /// [Email 登录功能]
  ///
  /// [传入参数]
  /// - [email] 注册邮箱
  /// - [password] 密码
  ///
  /// [回传值]
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [String]邮箱 | 失败: null
  Future<AppResponse> signInWithEmail(String email, String password) async =>
      firebaseAuthRepository.signInWithEmailAndPassword(email, password);

  /// [使用Google账号登录功能]
  ///
  /// [回传值]
  /// - [AppResponse]
  ///   - message: 错误代码
  ///   - data: 成功:[UserCredential] ｜ 失败:null
  Future<AppResponse> signInWithGoogle() async =>
      firebaseAuthRepository.signInWithGoogle();

  /// [登出功能]
  ///
  /// [回传值]
  /// - [AppResponse]
  ///   - message: [String]错误代码
  ///   - data: 成功: [String]uid | 失败: null
  Future<AppResponse> signOut() async => firebaseAuthRepository.signOut();

  @override
  void onInit() {
    logger.i('接入 AuthApi');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('断开 AuthApi');
    super.onClose();
  }
}
