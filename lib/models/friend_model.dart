import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  late int messageNotRead;
  late String friendName;
  late String friendUid;
  late String lastMessage;
  late Timestamp lastMessageTime;
  String? friendType;

  FriendModel({
    required this.messageNotRead,
    required this.friendName,
    required this.lastMessage,
    required this.friendUid,
  });

  FriendModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;

      messageNotRead = data['messageNotRead'];
      friendName = data['friendName'];
      friendUid = data['friendUid'];
      lastMessage = data['lastMessage'];
      lastMessageTime = data['lastMessageTime'] ?? Timestamp.now();
      friendType = data['friendType'];
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }
}
