import 'package:firebase_auth/firebase_auth.dart';

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
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        return 'weak password';
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        return 'account already exists';
      }
    } catch (e) {
      print(e);
    }
    return 'register failed';
  }
}
