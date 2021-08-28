import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchUserModel {
  late String userName;
  late String userEmail;

  SearchUserModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      userName = data['userName'];
      userEmail = data['userEmail'];
      logger.d(userEmail);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  Map<String, dynamic> toJson(String userName, String userEmail) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    return data;
  }
}
