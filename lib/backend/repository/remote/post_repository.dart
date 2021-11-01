import 'dart:async';
import 'package:get/get.dart';
import 'package:paclub/constants/log_message.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 什么时候用 static function？，当这个 function 跟其他数据 object 的 data 没有交互的时候
/// 很明显 database 这个 class 并没有 data 属性在内，只有 function
/// ！！！static function 不能 access object data

/// 能夠給其他Function調用Firebase所儲存的資料
// TODO: Post Repository
class PostRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _postsCollection = FirebaseFirestore.instance.collection('posts');
  // MARK: 初始化
  @override
  void onInit() {
    logger3.i('初始化 PostRepository' + (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    // 设定是否使用 Firebase Emulator
    if (useFirestoreEmulator) {
      _firestore.useFirestoreEmulator(localhost, firestorePort);
      _firestore.settings = Settings(
        host: '$localhost:$firestorePort',
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 PostRepository' + (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    super.onClose();
  }

  // MARK: GET 部分
  /// ## NOTE: 获取 Pack 的 Stream

  // MARK: UPDATE 部分
  /// ## NOTE: 更新 Post 收纳盒
  Future<AppResponse> updatePost({
    required String postId,
    required Map<String, dynamic> updateMap,
  }) async {
    logger.i('更新 Post: $postId\n$updateMap');

    return _postsCollection.doc(postId).update(updateMap).timeout(const Duration(seconds: 10)).then(
      (_) async {
        logger.i('更新 Post 成功, pid: $postId');
        return AppResponse(kUpdatePostSuccess, postId);
      },
      onError: (e) {
        logger3.e('更新 Post 失败, error: ' + e.runtimeType.toString());
        return AppResponse(kUpdatePostFail, null);
      },
    );
  }

  // MARK: SET 部分

  /// ## NOTE: 创建 Post
  Future<AppResponse> setPost({
    required PostModel postModel,
  }) async {
    DocumentReference documentReference = _postsCollection.doc();
    // NOTE: 将 Document id 作为一个 field 写入 pack document
    logger.i('开始创建 Post');

    return documentReference
        .set(postModel.toJson(postId: documentReference.id))
        .timeout(const Duration(seconds: 10))
        .then(
      (_) async {
        logger.i('创建 Post 成功, pid: ${documentReference.id}');
        return AppResponse(kAddPostSuccess, documentReference.id);
      },
      onError: (e) {
        logger3.e('创建 Post 失败, error: ' + e.runtimeType.toString());
        return AppResponse(kAddPostFail, null);
      },
    );
  }
}
