import 'package:get/get.dart';
import 'package:paclub/backend/api/auth_api.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomModel {
  final AuthApi authApi = Get.find<AuthApi>();
  late String userName;
  late String chatroomId;

  ChatroomModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      userName = data['chatRoomId']
          .replaceAll("_", "")
          .replaceAll(authApi.user!.displayName, "");
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
