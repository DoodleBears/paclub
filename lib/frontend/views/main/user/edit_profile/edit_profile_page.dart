import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paclub/frontend/views/main/user/components/appber_widget.dart';
import 'package:paclub/frontend/views/main/user/components/button_widget.dart';
import 'package:paclub/frontend/views/main/user/components/profile_widget.dart';
import 'package:paclub/frontend/views/main/user/components/textfield_widget.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';

class EditProfilePage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— EditProfilePage');
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          GetBuilder<UserController>(
            builder: (_) {
              return ProfileWidget(
                imagePath: controller.imagePath,
                isEdit: true,
                onClicked: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (image == null) return;

                  final directory = await getApplicationDocumentsDirectory();
                  final name = basename(image.path);
                  final imageFile = File('${directory.path}/$name');
                  final newImage = await File(image.path).copy(imageFile.path);
                  controller.imagePath = newImage.path;
                  controller.update();
                  // setState(() => user = user.copy(imagePath: newImage.path));
                },
              );
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<UserController>(
            builder: (_) {
              return TextFieldWidget(
                label: 'Full Name',
                text: controller.name,
                onChanged: (name) => controller.name = name,
              );
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: controller.email,
            onChanged: (email) => controller.email = email,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
              label: 'About',
              text: controller.about,
              maxLines: 5,
              onChanged: (about) => controller.about = about),
          const SizedBox(height: 24),
          ButtonWidget(
            text: 'Save',
            onClicked: () {
              controller.setUserPreference();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
