import 'package:firebase_auth/firebase_auth.dart';

// LoginRepository 管理login的仓库管理员，会有和 firebase 等 Database 连接&数据传输的具体 code
class LoginRepository {
  Future<String> login(String username, String password) async {
    try {
      // FirebaseAuth 提供的方式
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      if (userCredential.user.email != null) return 'login successed';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password';
      } else if (e.code == '') {}
    }
    return 'login failed';
  }
}
