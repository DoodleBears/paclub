import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: Recent Post 的内容
class PackModel {
  late String pid;
  late String name;
  late List<String>? tags = <String>[];
  late String description;
  late String photoURL;
  late Timestamp createdAt;
  late Timestamp lastUpdateAt;

  PackModel({
    required this.pid,
    required this.name,
    this.tags,
    this.description = '',
    this.photoURL = '',
  });

  PackModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      pid = documentSnapshot.id;
      name = data['name'];
      tags = data['tags'];
      description = data['description'];
      photoURL = data['photoURL'] ?? '';
      createdAt = data['createdAt'];
      lastUpdateAt = data['lastUpdateAt'];
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['tags'] = tags;
    data['description'] = description;
    data['photoURL'] = photoURL;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['lastUpdateAt'] = FieldValue.serverTimestamp();

    return data;
  }
}
