import 'package:firebase_auth/firebase_auth.dart';
import 'package:paclub/widgets/logger.dart';

class RegisterRepository {
  Future<String> register(String username, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      if (userCredential.user.email != null) return 'register successed';
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      if (e.code == 'weak-password') return 'weak password';
      if (e.code == 'invalid-email') return 'email form isn\'t right';
      if (e.code == 'email-already-in-use') return 'account already exists';
      if (e.code == 'too-many-requests')
        return 'you have try too many times\nplease wait 30 secs';
      if (e.code == 'unknown') return 'check your internet connection';
    } catch (e) {
      print(e);
    }
    return 'Register failed';
  }
}
