import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';
import 'package:paclub/frontend/utils/length_limit_textfield_formatter.dart';
import 'package:paclub/frontend/views/create_pack/create_pack_controller.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/widgets/avatar/multi_avatar_container.dart';
import 'package:paclub/frontend/widgets/buttons/stadium_button.dart';
import 'package:paclub/frontend/widgets/input_field/simple_input_field.dart';
import 'package:paclub/frontend/widgets/others/app_scroll_behavior.dart';

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
        title: Text('Create Pack'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: GetBuilder<CreatePackController>(
              builder: (_) {
                return StadiumButton(
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
      body: Padding(
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
                  child: GetBuilder<AppController>(
                    builder: (_) {
                      return Container(
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
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  clipBehavior: Clip.antiAlias,
                                  child: controller.imageFile == null
                                      ? Container(
                                          width: 128,
                                          height: 128,
                                          child: Icon(
                                            Icons.add_a_photo_rounded,
                                            size: 32.0,
                                          ),
                                        )
                                      : Ink.image(
                                          image:
                                              FileImage(controller.imageFile!),
                                          fit: BoxFit.cover,
                                          width: 128,
                                          height: 128,
                                        ),
                                ),
                                controller.imageFile == null
                                    ? SizedBox.shrink()
                                    : Positioned(
                                        right: -10.0,
                                        bottom: -10.0,
                                        child: GestureDetector(
                                          onTap: () =>
                                              controller.removePackPhoto(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: AppColors.normalTextColor,
                                              size: 28.0,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                // NOTE: Pack 名字
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GetBuilder<CreatePackController>(
                    builder: (_) {
                      return SimpleInputField(
                        titleText: 'Pack Name',
                        barColor: accentColor,
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
                        onChanged: controller.onDescriptionChanged,
                        titleText: 'Description',
                        maxLines: 5,
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
                    return Wrap(
                      spacing: 4.0,
                      runSpacing: -8.0,
                      children: controller.packModel.tags.map(
                        (String tag) {
                          return Chip(
                            onDeleted: () {
                              controller.deleteTag(tag);
                            },
                            label: Text(tag),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
                GetBuilder<CreatePackController>(
                  builder: (_) {
                    return TextField(
                      controller: controller.tagsTextEditingController,
                      onChanged: controller.onTagsChanged,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextFieldFormatterFixed(128)
                      ],
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        suffixIconConstraints:
                            BoxConstraints.tight(Size(32.0, 32.0)),
                        suffixIcon: GestureDetector(
                          onTap: controller.addTag,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.circleButtonBackgoundColor,
                            ),
                            child: Icon(
                              Icons.add,
                              color: AppColors.normalTextColor,
                            ),
                          ),
                        ),
                        hintText: 'Add',
                        errorText:
                            controller.isTagOK ? null : controller.errorText,
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
                    GetBuilder<AppController>(
                      builder: (_) {
                        return Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.profileAvatarBackgroundColor,
                          ),
                          child: Icon(
                            Icons.person_add_rounded,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
