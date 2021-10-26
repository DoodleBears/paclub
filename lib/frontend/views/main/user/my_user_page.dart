import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/user/profile/my_profile_page.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';

class MyUserPage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    controller.getUserProfile(isMe: true);

    return MyProfilePage();
  }
}
