import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';
import 'package:paclub/frontend/utils/length_limit_textfield_formatter.dart';
import 'package:paclub/frontend/views/create_pack/components/multi_line_tags.dart';
import 'package:paclub/frontend/views/create_pack/create_pack_controller.dart';
import 'package:paclub/frontend/widgets/avatar/multi_avatar_container.dart';
import 'package:paclub/frontend/widgets/buttons/stadium_loading_button.dart';
import 'package:paclub/frontend/widgets/containers/fade_in_scale_container.dart';
import 'package:paclub/frontend/widgets/input_field/simple_input_field.dart';
import 'package:paclub/frontend/widgets/others/no_glow_scroll_behavior.dart';

class CreatePackBody extends GetView<CreatePackController> {
  const CreatePackBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48.0,
        elevation: 0.5,
        leadingWidth: 50.0,
        centerTitle: true,
        title: GetBuilder<CreatePackController>(
          assignId: true,
          id: 'progress_bar',
          builder: (_) {
            return controller.processInfo == ''
                ? Text('Create Pack')
                : Text(
                    controller.processInfo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: GetBuilder<CreatePackController>(
              builder: (_) {
                return StadiumLoadingButton(
                  height: 18.0,
                  isLoading: controller.isLoading,
                  onTap: () {
                    controller.createPack();
                  },
                  buttonColor: accentColor,
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NOTE: Pack 封面
                    GestureDetector(
                      onTap: () {
                        // NOTE: 选择图片
                        controller.setPackPhoto();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 24.0,
                          bottom: 12.0,
                        ),
                        child: GetBuilder<CreatePackController>(
                          builder: (_) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  clipBehavior: Clip.antiAlias,
                                  child: controller.imageFile == null
                                      ? Container(
                                          width: 128,
                                          height: 128,
                                          color: AppColors.profileAvatarBackgroundColor,
                                          child: Icon(
                                            Icons.add_photo_alternate_rounded,
                                            size: 36.0,
                                          ),
                                        )
                                      : Ink.image(
                                          image: FileImage(controller.imageFile!),
                                          fit: BoxFit.cover,
                                          width: 128,
                                          height: 128,
                                        ),
                                ),
                                controller.imageFile == null
                                    ? SizedBox.shrink()
                                    : Positioned(
                                        right: 10.0,
                                        top: 10.0,
                                        child: GestureDetector(
                                          onTap: () => controller.removePackPhoto(),
                                          child: Container(
                                            padding: EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black.withAlpha(128),
                                            ),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: AppColors.normalTextColor,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    // NOTE: Pack 名字
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GetBuilder<CreatePackController>(
                        builder: (_) {
                          return SimpleInputField(
                            controller: controller.packNameTextEditingController,
                            titleText: 'Pack Name',
                            barColor: accentColor,
                            maxLines: 3,
                            onChanged: controller.onPackNameChanged,
                            error: controller.isPackNameOK == false,
                            errorText: controller.errorText,
                          );
                        },
                      ),
                    ),
                    // NOTE: Pack 简介
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GetBuilder<CreatePackController>(
                        builder: (_) {
                          return SimpleInputField(
                            controller: controller.descriptionTextEditingController,
                            onChanged: controller.onDescriptionChanged,
                            titleText: 'Description',
                            maxLines: 8,
                            inputFormatters: [
                              LengthLimitingTextFieldFormatterFixed(2000),
                            ],
                          );
                        },
                      ),
                    ),
                    // NOTE: Pack tags

                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Tags',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    GetBuilder<CreatePackController>(
                      builder: (_) {
                        return MultiLineTags(
                          backgroundColor: AppColors.profileAvatarBackgroundColor,
                          tags: controller.packModel.tags,
                          onDeleted: (tag) {
                            controller.deleteTag(tag);
                          },
                        );
                      },
                    ),
                    GetBuilder<CreatePackController>(
                      builder: (_) {
                        return TextField(
                          controller: controller.tagsTextEditingController,
                          onChanged: controller.onTagsChanged,
                          maxLines: 1,
                          onEditingComplete: () {
                            controller.addTag();
                          },
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.text,
                          inputFormatters: [LengthLimitingTextFieldFormatterFixed(128)],
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 8.0),
                            suffix: GestureDetector(
                              onTap: controller.addTag,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.profileAvatarBackgroundColor,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 28.0,
                                  color: AppColors.normalTextColor,
                                ),
                              ),
                            ),
                            hintText: 'Add',
                            errorText: controller.isTagOK ? null : controller.errorText,
                          ),
                        );
                      },
                    ),

                    // NOTE: Pack 编辑者
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Editor',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MultiAvatarContainer(
                            avatarsUrl: controller.avatarsUrl,
                            width: 48.0,
                            height: 48.0,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.profileAvatarBackgroundColor,
                          ),
                          child: Icon(
                            Icons.person_add_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
          ),
          // NOTE: 进度条
          GetBuilder<CreatePackController>(
            assignId: true,
            id: 'progress_bar',
            builder: (_) {
              return Align(
                alignment: Alignment.topLeft,
                child: FadeInScaleContainer(
                  isShow: controller.processInfo != '',
                  color: controller.processInfo == 'Create Fail' ? Colors.red : accentColor,
                  height: 4.0,
                  width: Get.width * (controller.process / 3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
