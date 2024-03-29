import 'dart:convert';

import 'package:paclub/models/preference_model.dart';
import 'package:paclub/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [文件说明]
/// - 使用 shared_preferences 这个 package 来完成简单数据的存储
///
/// [使用场景]
/// - 存储用户偏好设置（通常为黑夜白天模式等，跟随终端的设置，不存储在Server中）
class UserPreference {
  // late(lateinit) 延迟初始化非空 Value，很明显我们在宣告的时候无法直接初始化 preferences，要从用户本机获取
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';
  static const myUserPreference = PreferenceModel(
    // imagePath: 'https://i.imgur.com/6y0Nvf6.jpg',
    // name: 'Mei Hsing',
    // email: 'mei@csie.fju.edu.tw',
    // about:
    //     'Our group has been focusing on web related research and development. Our current interests include Mobile Software, Development, Virtual World(Second Life), Emerging Web Technologies, Deep Web Intelligence, and Brain Informatics.',
    isDarkMode: false,
  );

  // Async 取得本地存储的 preference
  static Future init() async {
    logger.i('启用 UserPreferences');
    return _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserPreference(PreferenceModel userPreference) async {
    // object 转 json
    // jsonEncode() 只能直接编码 String int 等 primitive 的类型
    // 如果需要转自己宣告的object，建议先写 .toJson()
    final json = jsonEncode(userPreference.toJson());
    // debugPrint(json);
    // 将 json 以 string 形式存入 local storage
    await _preferences.setString(_keyUser, json);
  }

  // 因为 getUser 一定是在 user 初始化之后，所以不用 Async 一定可以取得
  static PreferenceModel getUserPreference() {
    final json = _preferences.getString(_keyUser);
    // 如果本地存储为空，则回传默认值 myUser
    return json == null
        ? myUserPreference
        : PreferenceModel.fromJson(jsonDecode(json));
  }
}
