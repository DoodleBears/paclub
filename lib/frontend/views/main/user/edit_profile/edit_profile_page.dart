import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/auth/login/components/components.dart';
import 'package:paclub/frontend/views/main/user/user_controller.dart';
import 'package:paclub/utils/logger.dart';

class EditProfilePage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    logger.i('渲染 —— EditProfilePage');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // z-index高度的感觉，影响 AppBar 的阴影
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.setAvatar();
                },
                child: GetBuilder<UserController>(
                  builder: (_) {
                    return ClipOval(
                      child: Material(
                        color: AppColors.profileAvatarBackgroundColor,
                        child: controller.myUserModel.avatarURL == '' &&
                                controller.imageFile == null
                            ? Container(
                                width: 128,
                                height: 128,
                              )
                            : Ink.image(
                                image: controller.imageFile == null
                                    ? CachedNetworkImageProvider(
                                        controller.avatarURLNew)
                                    : FileImage(controller.imageFile!)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                                width: 128,
                                height: 128,
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              RoundedInputField(
                controller: controller.displayNameTextController,
                textInputType: TextInputType.text,
                labelText: 'Full Name',
                onChanged: controller.onDisplayNameChanged,
              ),
              const SizedBox(height: 24),
              RoundedInputField(
                controller: controller.bioTextController,
                textInputType: TextInputType.text,
                labelText: 'Bio',
                maxLines: 5,
                onChanged: controller.onBioChanged,
              ),
              const SizedBox(height: 24),
              GetBuilder<UserController>(
                builder: (_) {
                  return RoundedLoadingButton(
                    text: 'Update',
                    color: controller.isProfileEdited
                        ? accentColor
                        : Colors.grey[400],
                    isLoading: controller.isSaveLoading,
                    width: controller.isSaveLoading
                        ? Get.width * 0.4
                        : Get.width * 0.8,
                    height: Get.height * 0.08,
                    onPressed: () async {
                      await controller.updateUserProfile();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
