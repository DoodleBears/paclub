import 'package:get/get.dart';
import 'package:paclub/utils/logger.dart';
import 'package:paclub/backend/repository/local/user_preferences.dart';
import 'package:paclub/models/user.dart';

class UserController extends GetxController {
  User user = UserPreferences.getUserPreference();
  int messageNotReadAll = 0;
  late String imagePath;
  late String name;
  late String email;
  late String about;
  late bool isDarkMode;

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
    super.onInit();
  }

  @override
  void onClose() {
    logger.w('关闭 UserController');
    super.onClose();
  }
}
