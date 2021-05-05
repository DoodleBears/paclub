import 'dart:convert';

import 'package:box_group/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyUser = 'user';
  static const myUser = User(
    imagePath: 'https://i.imgur.com/6y0Nvf6.jpg',
    name: 'Mei Hsing',
    email: 'mei@csie.fju.edu.tw',
    about:
        'Our group has been focusing on web related research and development. Our current interests include Mobile Software, Development, Virtual World(Second Life), Emerging Web Technologies, Deep Web Intelligence, and Brain Informatics.',
    isDarkMode: false,
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
