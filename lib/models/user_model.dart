import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String displayName;
  late String email;
  late String bio = '';

  UserModel({required this.displayName, required this.email});

  UserModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      uid = data['uid'];
      displayName = data['displayName'];
      email = data['email'];
      bio = data['bio'];
      logger.d(email);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  static Map<String, dynamic> toJson(
      {required String uid,
      required String displayName,
      required String email,
      required String bio}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;
    data['displayName'] = displayName;
    data['email'] = email;
    data['bio'] = bio;

    return data;
  }
}
