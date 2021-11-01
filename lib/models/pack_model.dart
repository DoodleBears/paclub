import 'package:cloud_firestore/cloud_firestore.dart';

class PackModel {
  late String pid;
  late String ownerUid;
  late String ownerName;
  late String ownerAvatarURL;
  late String packName;
  late String description;
  late String photoURL;
  late List<String> tags = <String>[];
  late Map<String, dynamic> editorInfo; // key: uid, value: ~~~
  late Timestamp createdAt;
  late Timestamp lastUpdateAt;
  late int thumbUpCount;
  late int favoriteCount;
  late int shareCount;
  late int commentCount;
  // TODO: 在 Pack 中添加 Recent Posts

  PackModel({
    required this.ownerUid,
    required this.ownerName,
    required this.packName,
    this.ownerAvatarURL = '',
    required this.editorInfo,
    required this.tags,
    this.description = '',
    this.photoURL = '',
  });

  PackModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      pid = documentSnapshot.id;
      ownerUid = data['ownerUid'];
      ownerName = data['ownerName'];
      ownerAvatarURL = data['ownerAvatarURL'];
      packName = data['packName'];
      description = data['description'];
      photoURL = data['photoURL'];
      List<dynamic> tempTags = data['tags'];
      tags = tempTags.map((e) => e.toString()).toList();
      editorInfo = data['editorInfo'];
      createdAt = data['createdAt'] ?? Timestamp.now();
      lastUpdateAt = data['lastUpdateAt'] ?? Timestamp.now();
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
    data['packName'] = packName;
    data['description'] = description;
    data['photoURL'] = photoURL;
    data['tags'] = tags;
    data['editorInfo'] = editorInfo;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['lastUpdateAt'] = FieldValue.serverTimestamp();
    data['thumbUpCount'] = 0;
    data['collectCount'] = 0;
    data['shareCount'] = 0;
    data['commentCount'] = 0;

    return data;
  }
}
