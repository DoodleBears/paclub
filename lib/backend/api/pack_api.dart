import 'package:get/get.dart';
import 'package:paclub/backend/repository/remote/pack_repository.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

class PackApi extends GetxController {
  final PackRepository _packRepository = Get.find<PackRepository>();

  // MARK: GET 部分
  /// ## NOTE: 获取 Pack 的 Stream
  Stream<List<PackModel>> getPackStream({
    required String uid,
  }) =>
      _packRepository.getPackStream(uid: uid);

  // MARK: UPDATE 部分
  /// ## NOTE: 更新 Pack 收纳盒
  Future<AppResponse> updatePack({
    required String pid,
    required Map<String, dynamic> updateMap,
  }) async =>
      _packRepository.updatePack(pid: pid, updateMap: updateMap);

  // MARK: SET 部分
  /// ## NOTE: 添加 Pack 收纳盒
  /// ## 传入参数
  /// - [packModel] Pack 收纳盒的信息
  ///
  /// ## 回传值
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: 成功: [String] Pack ID 收纳盒 ID | 失败: null
  Future<AppResponse> setPack({
    required PackModel packModel,
  }) async =>
      _packRepository.setPack(packModel: packModel);

  // MARK: 初始化
  @override
  void onInit() {
    logger.i('接入 PackApi');
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('断开 PackApi');
    super.onClose();
  }
}
