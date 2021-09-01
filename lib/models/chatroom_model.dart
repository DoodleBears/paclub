import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paclub/utils/logger.dart';

class ChatroomModel {
  late List<dynamic> users;
  late Map<String, dynamic> usersName;
  late String chatroomId;

  ChatroomModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      users = data['users'];
      usersName = data['usersName'];
      chatroomId = data['chatroomId'];
      logger.d(chatroomId);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }
}
