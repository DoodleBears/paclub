import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/backend/repository/local/user_preference.dart';
import 'package:paclub/models/preference_model.dart';

class AppController extends GetxController {
  PreferenceModel userPreferenceModel = UserPreference.getUserPreference();
  int messageNotReadAll = 0;
  String appBadgeSupported = 'Unknown';
  // TODO: 将该 imagePath 来源改为 Link (Firebase Storage)

  late bool isDarkMode;

  void setAppBadge({required int count}) {
    messageNotReadAll = count;
    update();
    if (appBadgeSupported != 'Supported') {
      return;
    }
    if (messageNotReadAll > 0) {
      FlutterAppBadger.updateBadgeCount(messageNotReadAll);
    } else {
      FlutterAppBadger.removeBadge();
    }
  }

  @override
  void onInit() async {
    isDarkMode = userPreferenceModel.isDarkMode;

    logger.i('启用 UserController');
    FlutterAppBadger.isAppBadgeSupported();
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 UserController');
    super.onClose();
  }
}
