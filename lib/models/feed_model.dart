import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FeedModel {
  late int feedType;
  late Timestamp createdAt;
  late Timestamp lastUpdateAt;
  late int thumbUpCount;
  late int favoriteCount;
  late int shareCount;
  late int commentCount;
}
