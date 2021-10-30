import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/views/main/user/components/numbers_widget.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/frontend/widgets/avatar/circle_avatar_container.dart';
import 'package:paclub/utils/logger.dart';

class ProfilePage extends GetView<UserController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— ProfilePage');

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // z-index高度的感觉，影响 AppBar 的阴影
      ),
      body: Column(
        children: [
          GetBuilder<AppController>(
            builder: (_) {
              return GetBuilder<UserController>(
                builder: (_) {
                  return CircleAvatarContainer(
                    avatarUrl: controller.otherUserModel.avatarURL,
                    width: 128,
                    height: 128,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<UserController>(
              builder: (_) =>
                  buildDisplayName(controller.otherUserModel.displayName)),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          GetBuilder<UserController>(
              builder: (_) => buildAbout(controller.otherUserModel.bio)),
        ],
      ),
    );
  }

  Widget buildDisplayName(String name) {
    return Text(
      name,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    );
  }

  Widget buildAbout(String about) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
