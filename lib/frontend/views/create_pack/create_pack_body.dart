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
            child: StadiumButton(
              onTap: () {},
              buttonColor: accentColor,
              child: Text(
                'Create',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTE: Pack 封面
                GestureDetector(
                  onTap: () {
                    // NOTE: 选择图片
                  },
                  child: GetBuilder<AppController>(
                    builder: (_) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 24.0,
                          bottom: 12.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: AppColors.profileAvatarBackgroundColor,
                        ),
                        child: Container(
                          width: 128,
                          height: 128,
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 32.0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // NOTE: Pack 名字
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SimpleInputField(
                    titleText: 'Pack Name',
                    barColor: accentColor,
                  ),
                ),
                // NOTE: Pack 简介
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SimpleInputField(
                    titleText: 'Description',
                    maxLines: 5,
                    inputFormatters: [
                      LengthLimitingTextFieldFormatterFixed(2000),
                    ],
                  ),
                ),
                // NOTE: Pack tags
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SimpleInputField(
                    titleText: 'Tags',
                    inputFormatters: [
                      LengthLimitingTextFieldFormatterFixed(256),
                    ],
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
