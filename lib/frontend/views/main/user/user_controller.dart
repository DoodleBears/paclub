import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/backend/repository/local/user_preferences.dart';
import 'package:paclub/models/user.dart';

class UserController extends GetxController {
  User user = UserPreferences.getUserPreference();
  int messageNotReadAll = 0;
  String appBadgeSupported = 'Unknown';
  late String imagePath;
  late String name;
  late String email;
  late String about;
  late bool isDarkMode;

  void setAppBadge({required int count}) {
    messageNotReadAll = count;
    update();
    // if (appBadgeSupported != 'Supported') {
    //   return;
    // }

    if (messageNotReadAll > 0) {
      FlutterAppBadger.updateBadgeCount(messageNotReadAll);
    } else {
      FlutterAppBadger.removeBadge();
    }
  }

  void setUserPreference() {
    UserPreferences.setUserPreference(user.copy(
      imagePath: imagePath,
      name: name,
      email: email,
      about: about,
      isDarkMode: isDarkMode,
    ));
    update();
  }

  @override
  void onInit() {
    imagePath = user.imagePath;
    name = user.name;
    email = user.email;
    about = user.about;
    isDarkMode = user.isDarkMode;

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
