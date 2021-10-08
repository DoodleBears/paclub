import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  late DocumentSnapshot documentSnapshot;
  late String message;
  late String sendBy;
  late Timestamp time;

  // 有 {} curly bracket 的话，初始化宣告变量的时候要指定变量名
  ChatMessageModel.withTime(this.message, this.sendBy, this.time);

  ChatMessageModel(this.message, this.sendBy);

  ChatMessageModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      this.documentSnapshot = documentSnapshot;
      message = data['message'];
      sendBy = data["sendBy"];
      time = data["time"];
      // logger.d(message);
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sendBy'] = sendBy;
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
