import 'package:paclub/helper/constants.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomModel {
  late String userName;
  late String chatroomId;

  ChatroomModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      // TODO: 修改chatroom的逻辑，把对方的Name也存成document
      userName = data['chatRoomId']
          .replaceAll("_", "")
          .replaceAll(Constants.myName, "");
      chatroomId = data['chatRoomId'];
      logger.d(userName);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = userName;
    data['message'] = chatroomId;
    return data;
  }
}
