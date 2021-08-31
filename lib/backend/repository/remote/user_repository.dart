import 'package:get/get.dart';
import 'package:paclub/constants/emulator_constant.dart';
import 'package:paclub/models/search_user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///能夠給其他Function調用Firebase所儲存的資料

class UserRepository extends GetxController {
  static const String kAddUserFailedError = 'add_user_failed';
  static const String kAddUserSuccessed = 'add_user_successed';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _users;

  @override
  void onInit() {
    logger3.i('初始化 UserRepository' + (useEmulator ? '(Emulator)' : ''));
    if (useEmulator) {
      _firestore.useFirestoreEmulator(localhost, firestorePort);
      _firestore.settings = Settings(
        host: '$localhost:$firestorePort',
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }
    _users = _firestore.collection('users');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 UserRepository' + (useEmulator ? '(Emulator)' : ''));
    super.onClose();
  }

  /// 添加新用户（设置信息）
  Future<AppResponse> addUser(Map<String, dynamic> userData) async {
    return _users.add(userData).then(
        (value) => AppResponse(kAddUserSuccessed, userData), onError: (e) {
      logger.e('添加用户失败，error: ' + e.runtimeType.toString());
      return AppResponse(kAddUserFailedError, null);
    });
  }

  /// 获取用户信息
  Future<AppResponse> getUserInfo(String email) async {
    return _users.where("userEmail", isEqualTo: email).snapshots().first.then(
        (QuerySnapshot querySnapshot) {
      SearchUserModel searchUserModel = querySnapshot.docs
          .map((doc) => SearchUserModel.fromDoucumentSnapshot(doc))
          .first;
      AppResponse appResponse = AppResponse('success', searchUserModel);
      return appResponse;
    }, onError: (e) {
      return AppResponse('failed', null);
    });
  }

  /// Search時，能夠找到相符合的用戶名稱
  // TODO：模糊搜索，搜索多个用户
  // FIXME: Error Handling 怎么做？
  Future<List<SearchUserModel>> searchByName(String searchText) async {
    return _users.where('userName', isEqualTo: searchText).get().then(
      (QuerySnapshot querySnapshot) => querySnapshot.docs
          .map((doc) => SearchUserModel.fromDoucumentSnapshot(doc))
          .toList(),
      onError: (e) {
        logger3.e(e);
        return List<SearchUserModel>.empty();
      },
    );
  }
}
