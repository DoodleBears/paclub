import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/utils/length_limit_textfield_formatter.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/views/write_post/components/drag_handler.dart';
import 'package:paclub/frontend/views/write_post/components/draggable_scrollable_attachable_sheet.dart';
import 'package:paclub/frontend/views/write_post/components/full_width_text_button.dart';
import 'package:paclub/frontend/views/write_post/components/pack_tile.dart';
import 'package:paclub/frontend/views/write_post/write_post_controller.dart';
import 'package:paclub/frontend/widgets/buttons/stadium_loading_button.dart';
import 'package:paclub/frontend/widgets/others/app_scroll_behavior.dart';
import 'package:paclub/frontend/widgets/widgets.dart';
import 'package:paclub/helper/app_constants.dart';
import 'package:paclub/r.dart';
import 'package:paclub/utils/logger.dart';

class WritePostBody extends GetView<WritePostController> {
  // 每次 重建ListView（一般是有新消息进入，则会重新计算高度）
  afterBuild() {
    if (controller.tagsScrollController.hasClients) {
      if (controller.isTagInputShow) {
        controller.scrollToBottom();
      }
    } else {
      logger.e('无法找到controller');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isBottomSheetShow) {
          controller.toggleBottomSheet(context);
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
              elevation: 0.5,
              leadingWidth: 64.0,
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
                      vertical: 8.0, horizontal: 8.0),
                  child: GetBuilder<WritePostController>(
                    builder: (_) {
                      return StadiumLoadingButton(
                        height: 18.0,
                        isLoading: controller.isLoading,
                        onTap: () {
                          controller.createPost();
                        },
                        buttonColor: accentColor,
                        child: Text(
                          '收納',
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
            body: GestureDetector(
              onVerticalDragEnd: (details) {
                double velocity = details.velocity.pixelsPerSecond.dy;
                if (velocity < -1600.0) {
                  controller.toggleBottomSheet(context);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NOTE: 标题
                  GetBuilder<WritePostController>(
                    builder: (_) {
                      return Visibility(
                        maintainState: true,
                        visible: controller.isContentFocused == false,
                        child: Container(
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
                              onChanged: controller.onTitleChanged,
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
                                errorText: controller.isTitleOK == false
                                    ? controller.errorText
                                    : null,
                                hintText: '標題',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // NOTE: tags
                  GetBuilder<WritePostController>(
                    builder: (_) {
                      if (controller.isContentFocused) {
                        return SizedBox.shrink();
                      }
                      WidgetsBinding.instance!
                          .addPostFrameCallback((_) => afterBuild());
                      List<Widget> widgets = [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Chip(
                            backgroundColor: accentColor.withAlpha(128),
                            shadowColor: Colors.transparent,
                            label: Text(
                              'Tags:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ];
                      List<Widget> chips = controller.postModel.tags.map(
                        (String tag) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: RawChip(
                              backgroundColor:
                                  AppColors.profileAvatarBackgroundColor,
                              deleteIcon: Icon(Icons.close_rounded),
                              onDeleted: () {
                                controller.deleteTag(tag);
                              },
                              labelStyle: TextStyle(
                                fontSize: 18.0,
                              ),
                              label: Text(tag),
                            ),
                          );
                        },
                      ).toList();

                      widgets.addAll(chips);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Colors.grey,
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: FullWidthTextButton(
                          alignment: Alignment.centerLeft,
                          backgroundColor:
                              AppColors.buttonLightBackgroundColor!,
                          height: 48.0,
                          onPressed: () {
                            controller.toggleTagInput();
                          },
                          child: ScrollConfiguration(
                            behavior: NoGlowScrollBehavior(),
                            child: SingleChildScrollView(
                              controller: controller.tagsScrollController,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              physics: BouncingScrollPhysics(),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: widgets,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // NOTE: tags 输入框
                  GetBuilder<WritePostController>(
                    builder: (_) {
                      return Visibility(
                        visible: controller.isTagInputShow,
                        child: TextField(
                          controller: controller.tagsTextEditingController,
                          focusNode: controller.tagsFocusNode,
                          onChanged: controller.onTagsChanged,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextFieldFormatterFixed(128)
                          ],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            suffix: GestureDetector(
                              onTap: controller.addTag,
                              child: GetBuilder<AppController>(
                                builder: (_) {
                                  return Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors
                                          .profileAvatarBackgroundColor,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 28.0,
                                      color: AppColors.normalTextColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                            hintText: 'Add',
                            errorText: controller.isTagOK
                                ? null
                                : controller.errorText,
                          ),
                        ),
                      );
                    },
                  ),

                  // NOTE: 输入内容
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 10.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42.0,
                            height: 42.0,
                            margin: const EdgeInsets.only(
                              top: 14.0,
                              right: 8.0,
                            ),
                            child: AppConstants.avatarURL == ''
                                ? Image.asset(
                                    R.appIcon, //使用Class调用内置图片地址
                                    fit: BoxFit.fitWidth,
                                  )
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: Material(
                                      shape: CircleBorder(),
                                      clipBehavior: Clip.antiAlias,
                                      child: Ink.image(
                                        fit: BoxFit.fitWidth,
                                        image: CachedNetworkImageProvider(
                                            AppConstants.avatarURL),
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: NoGlowScrollBehavior(),
                              child: GetBuilder<WritePostController>(
                                builder: (_) {
                                  return TextField(
                                    minLines: 1,
                                    maxLines: null,
                                    maxLength: 2000,
                                    focusNode: controller.contentFocusNode,
                                    onChanged: controller.onContentChanged,
                                    controller:
                                        controller.textEditingController,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                    decoration: InputDecoration(
                                      errorText: controller.isContentOK == false
                                          ? controller.errorText
                                          : null,
                                      contentPadding: EdgeInsets.only(top: 8.0),
                                      hintText: '記下想法、感受',
                                      hintStyle: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // NOTE: Functions
                  Container(
                    height: 48.0,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Colors.grey,
                          width: 0.2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_outlined,
                          size: 32.0,
                        ),
                      ],
                    ),
                  ),

                  // NOTE: 选择箱子
                  FullWidthTextButton(
                    height: 48.0,
                    backgroundColor: accentColor,
                    onPressed: () {
                      controller.toggleBottomSheet(context);
                    },
                    child: Text(
                      '選擇收納盒',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // NOTE: 点击 Choose Pack 后出现的顏色遮罩
          GetBuilder<WritePostController>(
            assignId: true,
            id: 'bottomSheet',
            builder: (_) {
              return GestureDetector(
                onTap: () {
                  controller.toggleBottomSheet(context);
                },
                child: FadeInScaleContainer(
                  opacityDuration: const Duration(milliseconds: 500),
                  isShow: controller.isBottomSheetShow,
                  color: AppColors.maskCurtainColor,
                ),
              );
            },
          ),
          // NOTE: 点击 Choose Pack 后出现的 Bottom Sheet, 用于选择要将 Post 收纳进哪一个 Pack
          GetBuilder<WritePostController>(
            assignId: true,
            id: 'bottomSheet',
            builder: (_) {
              return DraggableScrollableAttachableSheet(
                bottomSheetController: controller.bottomSheetController,
                height: Get.height * 0.5,
                fullyOpenHeight: Get.height * 0.8,
                isAllowFullyOpen: true,
                backgroundColor: AppColors.bottomSheetBackgoundColor,
                onDrag: (offset) {},
                onDragComplete: controller.onDragComplete,
                handlerWidget: DragHandler(),
                child: Expanded(
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // 用户所创建的所有 Pack 的 List
                        ListView.builder(
                          padding: EdgeInsets.only(bottom: Get.height * 0.1),
                          itemCount: controller.packList.length,
                          itemBuilder: (context, index) {
                            return PackTile(
                              photoURL: controller.packList[index].photoURL,
                              pid: controller.packList[index].pid,
                              packName: controller.packList[index].packName,
                              color: accentColor.withAlpha(32),
                              onChanged: (value) =>
                                  controller.onPackTileChanged(value, index),
                              value: controller.packCheckedList[
                                  controller.packList[index].pid],
                            );
                          },
                        ),

                        // 创建 Pack 的 Button
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.normalShadowColor!,
                                offset: Offset(0, 8.0),
                                blurRadius: 10.0,
                              ),
                            ],
                            color: AppColors.containerBackground,
                          ),
                          height: Get.height * 0.1,
                          child: TextButton(
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(Size.infinite),
                            ),
                            onPressed: () {
                              controller.navigateToCreatePackPage();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 16.0),
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: accentColor,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Create New Pack',
                                    style: TextStyle(
                                      color: AppColors.normalTextColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
