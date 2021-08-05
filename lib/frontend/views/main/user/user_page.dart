import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/user/profile/profile_page.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';

class UserPage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return ProfilePage();
  }
}
