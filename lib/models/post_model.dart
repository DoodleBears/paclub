import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: Post 的内容
class PostModel {
  late String postId;
  late String ownerUid;
  late String ownerName;
  late String ownerAvatarURL;
  late String title;
  late String content;
  late String photoURL;
  late List<String> tags = <String>[];
  late Map<String, dynamic> editorInfo; // key: uid, value: ~~~
  late Timestamp createdAt;
  late Timestamp lastUpdateAt;

  PostModel({
    required this.ownerUid,
    required this.ownerName,
    required this.title,
    this.ownerAvatarURL = '',
    required this.editorInfo,
    required this.tags,
    this.content = '',
    this.photoURL = '',
  });

  PostModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      postId = documentSnapshot.id;
      ownerUid = data['ownerUid'];
      ownerName = data['ownerName'];
      ownerAvatarURL = data['ownerAvatarURL'];
      title = data['title'];
      content = data['content'];
      photoURL = data['photoURL'];
      List<dynamic> tempTags = data['tags'];
      tags = tempTags.map((e) => e.toString()).toList();
      editorInfo = data['editorInfo'];
      createdAt = data['createdAt'];
      lastUpdateAt = data['lastUpdateAt'];
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // NOTE: 之所以没有 pid 是因为 pid 是在存入 Firestore 的时候生成的
    data['ownerUid'] = ownerUid;
    data['ownerName'] = ownerName;
    data['ownerAvatarURL'] = ownerAvatarURL;
    data['title'] = title;
    data['content'] = content;
    data['photoURL'] = photoURL;
    data['tags'] = tags;
    data['editorInfo'] = editorInfo;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['lastUpdateAt'] = FieldValue.serverTimestamp();

    return data;
  }
}
