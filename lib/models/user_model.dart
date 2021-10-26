import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String displayName;
  late String email;
  late String bio;
  late String avatarURL;
  late Timestamp createdAt;
  late Timestamp lastLoginAt;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.bio = '',
    this.avatarURL = '',
  });

  UserModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      uid = data['uid'];
      displayName = data['displayName'];
      email = data['email'];
      bio = data['bio'];
      avatarURL = data['avatarURL'] ?? '';
      lastLoginAt = data['lastLoginAt'];
      createdAt = data['createdAt'];
      // logger.d(email);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;
    data['displayName'] = displayName;
    data['email'] = email;
    data['bio'] = bio;
    data['avatarURL'] = avatarURL;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['lastLoginAt'] = FieldValue.serverTimestamp();

    return data;
  }
}
