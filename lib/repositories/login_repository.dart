import 'package:firebase_auth/firebase_auth.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/toast.dart';

// LoginRepository 管理login的仓库管理员，会有和 firebase 等 Database 连接&数据传输的具体 code
class LoginRepository {
  Future<User> login(String username, String password) async {
    try {
      // FirebaseAuth 提供的方式
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      // 如果 user 存在, 则回传user
      if (userCredential.user != null) return userCredential.user;
    } on FirebaseAuthException catch (e) {
      logger.d('Firebase Exception 错误码:' + e.code);
      if (e.code == 'user-not-found') toast('No user found for that email.');
      if (e.code == 'invalid-email') toast('email form isn\'t right');
      if (e.code == 'wrong-password') toast('Wrong password');
      if (e.code == 'too-many-requests')
        toast('you have try too many times\nplease wait 30 secs');
      if (e.code == 'unknown') toast('check your internet connection');
    }
    return null;
  }
}
