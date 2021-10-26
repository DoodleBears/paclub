import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  late DocumentSnapshot documentSnapshot;
  late String message;
  late String sendByUid;
  late Timestamp time;

  ChatMessageModel({required this.message, required this.sendByUid});

  ChatMessageModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      this.documentSnapshot = documentSnapshot;
      message = data['message'];
      sendByUid = data["sendByUid"] ?? '';
      time = data["time"];
      // logger.d(message);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sendByUid'] = sendByUid;
    data['message'] = message;
    // data['time'] = DateTime.now().millisecondsSinceEpoch;
    // 下面用到了 Firebase Server 的 timestamp
    data['time'] = FieldValue.serverTimestamp();

    return data;
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['name'] = this.sendBy;
  //   return data;
  // }
}
