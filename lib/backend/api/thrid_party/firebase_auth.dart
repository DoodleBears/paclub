import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';

class FirebaseAuthApi extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  /// [初始化 Service] 绑定监听 user 和 connectivity 状态
  @override
  void onInit() {
    super.onInit();
    logger.i('初始化 FirebaseAuthApi');
    // 一旦 _auth 状态改变, _user 就会被重新赋值
    // _user.bindStream(_auth.authStateChanges());
    _auth.authStateChanges().listen((User? user) {
      // 一旦用户丢失在线状态
      if (user == null) {
        logger.d('Firebase 检测到用户状态为: 未登录');
      } else {
        logger.d('用户登录: ' + user.uid);
      }
    });
  }

  /// [结束 Service] 关闭监听 user 状态
  @override
  void onClose() {
    logger.w('关闭 FirebaseAuthApi');
    super.onClose();
  }
}
