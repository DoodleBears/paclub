import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:paclub/routes/app_pages.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/toast.dart';

// 提供用户所有信息的 Service, 之所以是 `extends GetxService`
/// 是因为, 这是永恒存在于User使用期间的, 即整个App的使用期间的
/// 无论是登录, 还是没有登录, 都需要用到他
/// 【没登录时】：用它登录
/// 【登录后用】：它会存住用户的资料, 以便登出, 点赞, 等各种跟User有关的操作
class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User> _user = Rx<User>(null);
  // 获得 user
  User get user => _user.value;

  // 绑定 firebase 的 _auth, 以获得自动检测 User 状态的功能
  @override
  void onInit() {
    // 一旦 _auth 状态改变, _user 就会被重新赋值
    logger.i('初始化 AuthService');
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        logger.i('User is currently signed out!');
      } else {
        logger.i('User is signed in!');
      }
    });
    _user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 authService');
    super.onClose();
  }

  //* 判断是否登录
  bool isLogin({bool notify = true, bool jump = false}) {
    logger.i('user data: ' + (user == null ? 'null' : user.toString()));
    if (user == null) {
      // 是否跳出提示
      if (notify) toast('请先登录');
      // 是否要强制用户跳转到登录页面
      if (jump) {
        Get.until((route) => false);
        Get.toNamed(Routes.AUTH);
      }
      return false;
    } else {
      return true;
    }
  }

  //* 注册功能
  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      logger0.i('user: ' + _user.value.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      if (e.code == 'weak-password') toast('weak password');
      if (e.code == 'invalid-email') toast('email form isn\'t right');
      if (e.code == 'email-already-in-use') toast('account already exists');
      if (e.code == 'too-many-requests') {
        toast('you have try too many times\nplease wait 30 secs');
      }
      if (e.code == 'unknown') toast('check your internet connection');
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  //* 登录功能
  Future<bool> login(String email, String password) async {
    try {
      // FirebaseAuth 提供的方式
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 登录成功, log 出 uid
      logger0.i('user: ' + _user.value.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      logger.d('Firebase Exception 错误码:' + e.code);
      if (e.code == 'user-not-found') toast('No user found for that email.');
      if (e.code == 'invalid-email') toast('email form isn\'t right');
      if (e.code == 'wrong-password') toast('Wrong password');
      if (e.code == 'too-many-requests') {
        toast('you have try too many times\nplease wait 30 secs');
      }
      if (e.code == 'unknown') toast('check your internet connection');
    }
    return false;
  }

  //* 登出功能
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.until((route) => false);
      Get.toNamed(Routes.AUTH);
    } catch (e) {
      logger.w('Sign out 失败');
    }
  }
}
