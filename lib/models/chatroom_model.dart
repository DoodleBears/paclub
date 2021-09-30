import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomModel {
  late List<dynamic> users;
  late Map<String, dynamic> usersName;
  late String chatroomId;

  ChatroomModel(
      {required this.users, required this.usersName, required this.chatroomId});

  ChatroomModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      users = data['users'];
      usersName = data['usersName'];
      chatroomId = data['chatroomId'];
      // logger.d(chatroomId);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['users'] = users;
    data['usersName'] = usersName;
    data['chatroomId'] = chatroomId;

    return data;
  }
}
