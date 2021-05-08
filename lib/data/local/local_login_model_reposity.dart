import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paclub/data/models/login_bean.dart';

class LocalLoginModelRepository {
  static final String keyToken = 'user_token';

  // 登录和注册之后都会调用下面这个 Function，用来存储用户登录信息在用户设备的 disk 上，方便下次自动登录
  static saveLoginModel(User user) {
    // 在 main.dart 中调用 DenpendencyInjection.init() 后
    // 调用 Get.putAsync(() => AppSpController().init())
    // 最终调用 AppSpController().init() 结果会回传 SharedPreferences 的 Object
    // 此时 Get.putAsync() 便把这个 Object 作为 Controller put 到 Hashmap 中
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(keyToken, jsonEncode(user..getIdToken()));
  }

  static LoginBean getLoginModel() {
    // 此时之前Dependency_injection.dart 的
    /// `await Get.putAsync(() => AppSpController().init())` 的 SharedPreferences 被find()调用，
    SharedPreferences sp = Get.find<SharedPreferences>();
    try {
      // 试图从sp中getString，看看有没有这个key-value，pair，如果没有说明之前未登录过（没有存储登录状态到 disk）
      // 此时会 getString 会出发 error被catch，然后return null，说明用户未登录，需要再登录
      var json = sp.getString(keyToken);
      return LoginBean.fromJson(jsonDecode(json));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
