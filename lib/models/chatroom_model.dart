import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomModel {
  late List<dynamic> users;
  late Map<String, dynamic> usersName;
  late String chatroomId;

  ChatroomModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      // TODO: 修改chatroom的逻辑，把对方的Name也存成document
      users = data['users'];
      usersName = data['usersName'];
      // userName = data['chatroomId']
      //     .replaceAll("_", "")
      //     .replaceAll(Constants.myName, "");
      chatroomId = data['chatroomId'];
      logger.d(users);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }
}
