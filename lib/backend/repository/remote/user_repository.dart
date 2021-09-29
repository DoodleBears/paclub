import 'package:get/get.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///能夠給其他Function調用Firebase所儲存的資料

class UserRepository extends GetxController {
  static const String kAddUserFailedError = 'add_user_failed';
  static const String kAddUserSuccessed = 'add_user_successed';
  static const String kUpdateUserSuccessed = 'update_user_successed';
  static const String kUpdateUserFailedError = 'update_user_failed';
  static const String kSearchUserFailedError = 'search_user_failed';
  static const String kSearchUserSuccessed = 'search_user_successed';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    logger3.i('初始化 UserRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    if (useFirestoreEmulator) {
      _firestore.useFirestoreEmulator(localhost, firestorePort);
    }
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 UserRepository' +
        (useFirestoreEmulator ? '(useFirestoreEmulator)' : ''));
    super.onClose();
  }

  /// 添加新用户（设置信息）
  Future<AppResponse> addUser(UserModel userData) async {
    logger.i('addUser');
    // 判断是否要添加user
    bool isUserExist = await _firestore
        .collection('users')
        .doc(userData.uid)
        .get()
        .then((doc) {
      return doc.exists ? true : false;
    });

    if (isUserExist) {
      logger.w('用户已存在，无需再注册，更新上次登录时间');
      final Map<String, dynamic> updatedData = Map<String, dynamic>();
      updatedData['lastLoginAt'] = FieldValue.serverTimestamp();

      return _firestore
          .collection('users')
          .doc(userData.uid)
          .update(updatedData)
          .then((value) => AppResponse(kUpdateUserSuccessed, userData),
              onError: (e) {
        logger.e('更新用户信息失败，error: ' + e.runtimeType.toString());
        return AppResponse(kUpdateUserFailedError, null);
      });
    } else {
      logger.w('用户不存在，添加用户到 collection:users');
      return _firestore
          .collection('users')
          .doc(userData.uid)
          .set(userData.toJson())
          .then((value) => AppResponse(kAddUserSuccessed, userData),
              onError: (e) {
        logger.e('添加用户失败，error: ' + e.runtimeType.toString());
        return AppResponse(kAddUserFailedError, null);
      });
    }
  }

  /// Search時，能夠找到相符合的用戶名稱
  // TODO 模糊搜索，搜索多个用户，
  // TODO 如何处理 Timeout
  Future<AppResponse> searchByName(String searchText) async {
    return _firestore
        .collection('users')
        .where('displayName', isGreaterThanOrEqualTo: searchText)
        .limit(20)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        List<UserModel> list = querySnapshot.docs
            .map((doc) => UserModel.fromDoucumentSnapshot(doc))
            .toList();
        return AppResponse(kSearchUserSuccessed, list);
      },
      onError: (e) {
        logger3.e(e);
        return AppResponse(kSearchUserFailedError, null);
      },
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      return AppResponse(kSearchUserFailedError, null);
    });
  }
}
