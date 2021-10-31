import 'dart:async';
import 'package:get/get.dart';
import 'package:paclub/constants/log_message.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 什么时候用 static function？，当这个 function 跟其他数据 object 的 data 没有交互的时候
/// 很明显 database 这个 class 并没有 data 属性在内，只有 function
/// ！！！static function 不能 access object data

/// 能夠給其他Function調用Firebase所儲存的資料
// TODO: Pack Repository
class PackRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _packsCollection =
      FirebaseFirestore.instance.collection('packs');
  // MARK: 初始化
  @override
  void onInit() {
    logger3.i('初始化 PackRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
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
    logger.w('关闭 PackRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    super.onClose();
  }

  // MARK: GET 部分
  /// ## NOTE: 获取 Pack 的 Stream
  Stream<List<PackModel>> getPackStream({
    required String uid,
  }) {
    return _packsCollection.where('ownerUid', isEqualTo: uid).snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) => PackModel.fromDoucumentSnapshot(doc))
            .toList());
  }

  // MARK: UPDATE 部分
  /// ## NOTE: 更新 Pack 收纳盒
  Future<AppResponse> updatePack({
    required String pid,
    required Map<String, dynamic> updateMap,
  }) async {
    logger.i('更新Pack: $updateMap');

    return _packsCollection
        .doc(pid)
        .update(updateMap)
        .timeout(const Duration(seconds: 10))
        .then(
      (_) async {
        logger.i('更新Pack成功, pid: $pid');
        return AppResponse(kUpdatePackSuccess, pid);
      },
      onError: (e) {
        logger3.e('更新Pack失败, error: ' + e.runtimeType.toString());
        return AppResponse(kUpdatePackFail, null);
      },
    );
  }

  // MARK: SET 部分

  // TODO: Add Post to Pack 添加贴文到收纳盒

  /// ## NOTE: 添加 Pack 收纳盒
  Future<AppResponse> setPack({
    required PackModel packModel,
  }) async {
    DocumentReference documentReference = _packsCollection.doc();
    // NOTE: 将 Document id 作为一个 field 写入 pack document
    Map<String, dynamic> dataMap = packModel.toJson();
    logger.i('添加Pack : ${packModel.toJson()}');
    dataMap['pid'] = documentReference.id;

    return documentReference
        .set(dataMap)
        .timeout(const Duration(seconds: 10))
        .then(
      (_) async {
        logger.i('添加箱子成功, pid: ${documentReference.id}');
        return AppResponse(kAddPackSuccess, documentReference.id);
      },
      onError: (e) {
        logger3.e('添加箱子失败, error: ' + e.runtimeType.toString());
        return AppResponse(kAddPackFail, null);
      },
    );
  }
}
