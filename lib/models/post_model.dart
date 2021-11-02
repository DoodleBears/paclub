import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paclub/models/feed_model.dart';

class PostModel implements FeedModel {
  late DocumentSnapshot documentSnapshot;
  late String postId;
  late String ownerUid;
  late String ownerName;
  late String ownerAvatarURL;
  late String title;
  late List<String> tags = <String>[];
  late String content;
  late List<String> photoURLs = <String>[];
  late List<String> belongPids = <String>[]; // 所属的 packs (pack >= 1)
  @override
  late Timestamp createdAt;
  @override
  late Timestamp lastUpdateAt;
  @override
  int feedType = 1;
  @override
  late int thumbUpCount;
  @override
  late int favoriteCount;
  @override
  late int shareCount;
  @override
  late int commentCount;

  PostModel({
    required this.ownerUid,
    required this.ownerName,
    required this.ownerAvatarURL,
    required this.title,
    required this.content,
    required this.tags,
  });

  PostModel.fromDoucumentSnapshot(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.data() != null) {
      Map data = documentSnapshot.data() as Map;
      this.documentSnapshot = documentSnapshot;
      postId = documentSnapshot.id;
      ownerUid = data['ownerUid'];
      ownerName = data['ownerName'];
      ownerAvatarURL = data['ownerAvatarURL'];
      title = data['title'];
      List<dynamic> tempTags = data['tags'];
      tags = tempTags.map((tag) => tag.toString()).toList();
      content = data['content'];
      List<dynamic> tempPhotoURLs = data['photoURLs'];
      photoURLs = tempPhotoURLs.map((url) => url.toString()).toList();
      List<dynamic> tempBelongPids = data['belongPids'];
      belongPids = tempBelongPids.map((url) => url.toString()).toList();
      createdAt = data['createdAt'];
      lastUpdateAt = data['lastUpdateAt'];
      thumbUpCount = data['thumbUpCount'];
      favoriteCount = data['favoriteCount'];
      shareCount = data['shareCount'];
      commentCount = data['commentCount'];
    } else {
      throw Exception('Null DocumentSnapshot');
    }
  }

  Map<String, dynamic> toJson({required String postId}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // NOTE: 之所以没有 postId 是因为 postId 是在存入 Firestore 的时候生成的
    data['postId'] = postId;
    data['ownerUid'] = ownerUid;
    data['ownerName'] = ownerName;
    data['ownerAvatarURL'] = ownerAvatarURL;
    data['title'] = title;
    data['tags'] = tags;
    data['content'] = content;
    data['photoURLs'] = photoURLs;
    data['belongPids'] = belongPids;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['lastUpdateAt'] = FieldValue.serverTimestamp();
    data['thumbUpCount'] = 0;
    data['favoriteCount'] = 0;
    data['shareCount'] = 0;
    data['commentCount'] = 0;

    return data;
  }
}
