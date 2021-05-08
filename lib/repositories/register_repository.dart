import 'package:firebase_auth/firebase_auth.dart';
import 'package:paclub/widgets/logger.dart';
import 'package:paclub/widgets/toast.dart';

class RegisterRepository {
  Future<User> register(String username, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      // 如果 user 存在, 则回传user
      if (userCredential.user != null) return userCredential.user;
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      if (e.code == 'weak-password') toast('weak password');
      if (e.code == 'invalid-email') toast('email form isn\'t right');
      if (e.code == 'email-already-in-use') toast('account already exists');
      if (e.code == 'too-many-requests')
        toast('you have try too many times\nplease wait 30 secs');
      if (e.code == 'unknown') toast('check your internet connection');
    } catch (e) {
      print(e);
    }
    return null;
  }
}
