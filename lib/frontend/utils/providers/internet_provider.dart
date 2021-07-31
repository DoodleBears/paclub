import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/frontend/widgets/toast.dart';

class InternetProvider extends GetxService {
  String _connectionStatus = 'Unknown';
  static InternetProvider? _singleton;
  final Connectivity _connectivity = Connectivity();

  InternetProvider._() {
    logger.i('初始化 InternetProvider');
    _connectivity.onConnectivityChanged.listen((_updateConnectionStatus) {
      logger.d('网络链接状态改变, 现在为: ' + _updateConnectionStatus.toString());
    });
    // 初次连接状态检测
    isConnected();
  }

  // 回传单例, 如果 _singleton 为 null 的话, _singleton = InternetProvider._();
  factory InternetProvider() => _singleton ??= InternetProvider._();

  //* 获得当前的联网类型: (wifi, mobile, none)
  String get connectionState => _connectionStatus;

  //* 检查联网状态
  Future<bool> isConnected() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        toastBottom('Check your internet connection');
        return false;
      }
      return true;
    } on PlatformException catch (e) {
      logger.e(e.toString());
    }
    _updateConnectionStatus(result);
    return false;
  }

  //* 更新联网状态信息
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        _connectionStatus = 'wifi';
        break;
      case ConnectivityResult.mobile:
        _connectionStatus = 'mobile';
        break;
      case ConnectivityResult.none:
        _connectionStatus = 'none';
        break;
      default:
        _connectionStatus = 'Failed';
        break;
    }
  }

  /// [初始化 Service] 绑定监听 user 和 connectivity 状态
  @override
  void onInit() {
    super.onInit();
  }

  /// [结束 Service] 关闭监听 user 状态
  @override
  void onClose() {
    logger.w('关闭 InternetProvider');
    super.onClose();
  }
}
