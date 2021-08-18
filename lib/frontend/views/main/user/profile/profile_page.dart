import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/routes/app_pages.dart';
import 'package:paclub/frontend/views/main/user/components/appber_widget.dart';
import 'package:paclub/frontend/views/main/user/components/button_widget.dart';
import 'package:paclub/frontend/views/main/user/components/numbers_widget.dart';
import 'package:paclub/frontend/views/main/user/components/profile_widget.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/utils/logger.dart';

class ProfilePage extends GetView<UserController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— ProfilePage');
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          GetBuilder<UserController>(
            builder: (_) {
              return ProfileWidget(
                imagePath: controller.imagePath,
                onClicked: () {
                  Get.toNamed(Routes.EDIT_PROFILE);
                },
              );
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<UserController>(
              builder: (_) =>
                  buildNameAndEmail(controller.name, controller.email)),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          GetBuilder<UserController>(
              builder: (_) => buildAbout(controller.about)),
        ],
      ),
    );
  }

  Widget buildNameAndEmail(String name, String email) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade To PRO',
        onClicked: () {},
      );

  Widget buildAbout(String about) => Container(
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
      );
}
