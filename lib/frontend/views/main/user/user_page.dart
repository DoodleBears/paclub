import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/user/profile/profile_page.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';

class UserPage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    controller.getUserProfile(isMe: false);

    return GetBuilder<UserController>(builder: (_) {
      return controller.isLoadProfile
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0, // z-index高度的感觉，影响 AppBar 的阴影
              ),
              body: Center(
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            )
          : ProfilePage();
    });
  }
}
