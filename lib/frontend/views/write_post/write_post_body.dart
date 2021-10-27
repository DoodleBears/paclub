import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/utils/length_limit_textfield_formatter.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/views/write_post/components/choose_pack_bottom_sheet.dart';
import 'package:paclub/frontend/views/write_post/write_post_controller.dart';
import 'package:paclub/frontend/widgets/buttons/stadium_button.dart';
import 'package:paclub/frontend/widgets/others/app_scroll_behavior.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/r.dart';
import 'package:paclub/utils/logger.dart';

class WritePostBody extends GetView<WritePostController> {
  const WritePostBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isBottomSheetShow) {
          controller.toggleBottomSheet();
          return false;
        } else {
          return true;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              toolbarHeight: 48.0,
              elevation: 0.0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Center(
                  child: Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 8.0),
                  child: StadiumButton(
                    onTap: () {},
                    buttonColor: accentColor,
                    child: Text(
                      '收纳',
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
            body: Column(
              children: [
                // NOTE: 标题
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey,
                        width: 0.2,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 2.0,
                  ),
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: TextField(
                      selectionHeightStyle:
                          BoxHeightStyle.includeLineSpacingBottom,
                      inputFormatters: [
                        LengthLimitingTextFieldFormatterFixed(128),
                      ],
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: '标题',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                // NOTE: 输入内容
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 14.0,
                            ),
                            child: Image.asset(
                              R.appIcon, //使用Class调用内置图片地址
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Flexible(child: SizedBox.expand()),
                        Flexible(
                          flex: 40,
                          child: ScrollConfiguration(
                            behavior: NoGlowScrollBehavior(),
                            child: TextField(
                              minLines: 1,
                              maxLines: null,
                              maxLength: 2000,
                              controller: controller.textEditingController,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              decoration: InputDecoration(
                                hintText: '记下想法、情感？',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // NOTE: Functions
                Container(
                  color: Colors.grey[700],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Center(
                      child: Text(
                        'Functions',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  width: double.infinity,
                ),
                // NOTE: 选择箱子
                Container(
                  height: 48.0,
                  child: TextButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size.infinite),
                    ),
                    onPressed: () {
                      logger0.d('按下 Choose Pack');
                      controller.toggleBottomSheet();
                    },
                    child: Text(
                      'Choose Pack',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<AppController>(
            builder: (_) {
              return GetBuilder<WritePostController>(
                builder: (_) {
                  return GestureDetector(
                    onTap: () {
                      controller.toggleBottomSheet();
                    },
                    child: FadeInScaleContainer(
                      opacityDuration: const Duration(milliseconds: 300),
                      isShow: controller.isBottomSheetShow,
                      color: AppColors.maskCurtainColor,
                    ),
                  );
                },
              );
            },
          ),
          GetBuilder<WritePostController>(
            builder: (_) {
              return ChoosePackBottomSheet(
                isBottomSheetShow: controller.isBottomSheetShow,
                height: Get.height * 0.6,
                fullyOpenHeight: Get.height * 0.9,
                onDragComplete: controller.onDragComplete,
                child: Container(
                  height: 100.0,
                  color: accentColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
