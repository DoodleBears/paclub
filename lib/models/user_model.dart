import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String displayName;
  late String email;
  late int createdAt;
  late int lastLoginAt;
  late String bio;

  UserModel(
      {required this.uid,
      required this.displayName,
      this.bio = '',
      required this.email});

  UserModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      uid = data['uid'];
      displayName = data['displayName'];
      email = data['email'];
      bio = data['bio'];
      lastLoginAt = data['lastLoginAt'];
      createdAt = data['createdAt'];
      logger.d(email);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;
    data['displayName'] = displayName;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['lastLoginAt'] = FieldValue.serverTimestamp();
    data['email'] = email;
    data['bio'] = bio;

    return data;
  }
}
