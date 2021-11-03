import 'dart:io';
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
import 'package:paclub/frontend/views/write_post/components/select_pack_tile.dart';
import 'package:paclub/frontend/views/write_post/write_post_controller.dart';
import 'package:paclub/frontend/widgets/buttons/animated_scale_floating_action_button.dart';
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
        controller.scrollToTagsRowBottom();
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
              centerTitle: true,
              title: GetBuilder<WritePostController>(
                assignId: true,
                id: 'progress_bar',
                builder: (_) {
                  return controller.processInfo == ''
                      ? Text('Post')
                      : Text(
                          controller.processInfo,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                },
              ),
              leadingWidth: 64.0,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Center(
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: GetBuilder<WritePostController>(
                    builder: (_) {
                      return StadiumLoadingButton(
                        height: 18.0,
                        isLoading: controller.isLoading,
                        onTap: () {
                          controller.createPost(context);
                        },
                        buttonColor: accentColor,
                        child: Text(
                          '收納',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
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
                ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
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
                                  border: Border(
                                    bottom: BorderSide(
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
                                    focusNode: controller.titleFocusNode,
                                    controller: controller.titleTextController,
                                    onChanged: controller.onTitleChanged,
                                    onEditingComplete: () {
                                      controller.finishTitle();
                                    },
                                    selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
                                    inputFormatters: [
                                      LengthLimitingTextFieldFormatterFixed(128),
                                    ],
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 18.0,
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
                            if (controller.isContentFocused || controller.isTagShow == false) {
                              return SizedBox.shrink();
                            }
                            WidgetsBinding.instance!.addPostFrameCallback((_) => afterBuild());
                            List<Widget> widgets = [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Chip(
                                  // backgroundColor: accentColor.withAlpha(128),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                  child: RawChip(
                                    backgroundColor: AppColors.profileAvatarBackgroundColor,
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
                              color: Colors.transparent,
                              child: FullWidthTextButton(
                                alignment: Alignment.centerLeft,
                                overlayColor: Colors.grey.withAlpha(24),
                                height: 48.0,
                                onPressed: () {
                                  controller.toggleTagInput();
                                },
                                child: ScrollConfiguration(
                                  behavior: NoGlowScrollBehavior(),
                                  child: SingleChildScrollView(
                                    controller: controller.tagsScrollController,
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    physics: BouncingScrollPhysics(),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: widgets,
                                        ),
                                      ],
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
                                onEditingComplete: () {
                                  controller.addTag();
                                },
                                inputFormatters: [LengthLimitingTextFieldFormatterFixed(128)],
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
                                            color: AppColors.profileAvatarBackgroundColor,
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
                                  errorText: controller.isTagOK ? null : controller.errorText,
                                ),
                              ),
                            );
                          },
                        ),
                        // NOTE: 输入内容
                        Container(
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
                                            image:
                                                CachedNetworkImageProvider(AppConstants.avatarURL),
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
                                        controller: controller.contentTextController,
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
                        // NOTE: 图像
                        GetBuilder<WritePostController>(
                          builder: (_) {
                            if (controller.imageFiles.length == 0) {
                              return SizedBox.shrink();
                            }
                            final List<Widget> widgets = [];
                            double height = 0.0;
                            double width = 0.0;
                            for (int index = 0; index < controller.imageFiles.length; index++) {
                              height = controller.imageHeight;
                              width = controller.imageHeight * controller.imageFilesRatio[index];
                              if (controller.imageFiles.length == 1 &&
                                  controller.imageFilesRatio[index] > 1) {
                                height = controller.imageHeight / controller.imageFilesRatio[index];
                                width = controller.imageHeight;
                              }

                              widgets.add(
                                Padding(
                                  padding: controller.imageBlockPadding,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Material(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Ink.image(
                                          image: FileImage(controller.imageFiles[index]),
                                          fit: BoxFit.cover,
                                          height: height,
                                          width: width,
                                        ),
                                      ),
                                      Positioned(
                                        right: 8.0,
                                        top: 8.0,
                                        child: GestureDetector(
                                          onTap: () => controller.removePostPhoto(index),
                                          child: FadeInScaleContainer(
                                            isShow: true,
                                            opacityDuration: const Duration(milliseconds: 300),
                                            padding: EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: controller.isUploadProcessesFinish[index]
                                                  ? accentColor
                                                  : Colors.black.withAlpha(192),
                                              border: controller.isUploadProcessesFinish[index]
                                                  ? Border.all(color: Colors.white, width: 2.0)
                                                  : null,
                                            ),
                                            child: Icon(
                                              controller.isUploadProcessesFinish[index]
                                                  ? Icons.check_rounded
                                                  : Icons.close_rounded,
                                              color: Colors.white,
                                              size: 28.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return FadeInScaleContainer(
                              height: height + controller.imageBlockVerticalPadding * 2,
                              isShow: controller.imageFiles.length > 0,
                              scaleDuration: const Duration(milliseconds: 300),
                              scaleCurve: Curves.easeOutCubic,
                              child: ScrollConfiguration(
                                behavior: NoGlowScrollBehavior(),
                                child: SingleChildScrollView(
                                  clipBehavior: Clip.none,
                                  padding: EdgeInsets.only(
                                    left: 64.0,
                                    right: 8.0,
                                  ),
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: widgets,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        // NOTE: 复制输入内容
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 40.0,
                          ),
                          child: TextField(
                            scrollPhysics: NeverScrollableScrollPhysics(),
                            minLines: 1,
                            maxLines: 7,
                            controller: controller.contentTextControllerCopy,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.transparent,
                            ),
                            decoration: InputDecoration(
                              enabled: false,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // NOTE: 进度条
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: GetBuilder<WritePostController>(
                    assignId: true,
                    id: 'progress_bar',
                    builder: (_) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: FadeInScaleContainer(
                          isShow: controller.processInfo != '',
                          color: controller.processInfo == 'Create Fail' ? Colors.red : accentColor,
                          height: 4.0,
                          width:
                              Get.width * (controller.process / (controller.imageFiles.length + 2)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<WritePostController>(
            builder: (_) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                bottom: Platform.isIOS ? 112.0 : 96.0,
                left: controller.process > 0 ? 0.0 : -140.0,
                right: 0.0,
                child: OpacityChangeContainer(
                  isShow: controller.process > 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.up,
                    children: [
                      FadeInScaleContainer(
                        isShow: true,
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // 上传图片进程
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.process > 0
                                    ? accentColor
                                    : Colors.black.withAlpha(192),
                                border: Border.all(color: Colors.white, width: 2.0),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 28.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text('设定 Post'),
                          ],
                        ),
                      ),
                      FadeInScaleContainer(
                        isShow: controller.imageFiles.length > 0,
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // 上传图片进程
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.isUploadProcessesFinish
                                        .every((element) => element == true)
                                    ? accentColor
                                    : Colors.black.withAlpha(192),
                                border: Border.all(color: Colors.white, width: 2.0),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 28.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text('上传图片'),
                          ],
                        ),
                      ),
                      FadeInScaleContainer(
                        isShow: true,
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // 上传图片进程
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.process == controller.imageFiles.length + 2
                                    ? accentColor
                                    : Colors.black.withAlpha(192),
                                border: Border.all(color: Colors.white, width: 2.0),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 28.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text('完成创建 Post'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // NOTE: Functions
          Positioned(
            bottom: Platform.isIOS ? 64.0 : 48.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 48.0,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.grey,
                    width: 0.2,
                  ),
                ),
                color: AppColors.containerBackground,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.pickImages(context);
                    },
                    icon: Icon(
                      Icons.photo_outlined,
                      size: 28.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.openTag();
                    },
                    icon: Icon(
                      Icons.tag_rounded,
                      size: 28.0,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      controller.cleanPostInfo();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '清空',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // NOTE: 选择箱子
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: AppColors.containerBackground,
              child: FullWidthTextButton(
                height: Platform.isIOS ? 64.0 : 48.0,
                overlayColor: Colors.grey.withAlpha(24),
                onPressed: () {
                  controller.toggleBottomSheet(context);
                },
                child: Text(
                  '選擇收納盒',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColors.normalTextColor!,
                  ),
                ),
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
                handlerWidget: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: DragHandler(),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            iconSize: 36.0,
                            onPressed: controller.navigateToCreatePackPage,
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              size: 36.0,
                              color: AppColors.normalGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                child: Expanded(
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // 用户所创建的所有 Pack 的 List
                        ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 20.0),
                          itemCount: controller.packList.length,
                          itemBuilder: (context, index) {
                            return SelectPackTile(
                              photoURL: controller.packList[index].photoURL,
                              description: controller.packList[index].description,
                              packName: controller.packList[index].packName,
                              color: primaryColor.withAlpha(48),
                              onChanged: (value) => controller.onPackTileChanged(value, index),
                              value: controller.packCheckedList[controller.packList[index].pid],
                            );
                          },
                        ),

                        // NOTE: 收納 Pack 的 Button
                        GetBuilder<WritePostController>(
                          builder: (_) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: Platform.isIOS ? 32.0 : 20.0),
                              child: AnimatedScaleFloatingActionButton(
                                isButtonShow: controller.postModel.title.isNotEmpty &&
                                    controller.postModel.belongPids.isNotEmpty,
                                onPressed: () {
                                  controller.toggleBottomSheet(context);
                                  controller.createPost(context);
                                },
                                child: Icon(
                                  Icons.move_to_inbox,
                                  color: Colors.white,
                                  size: 32.0,
                                ),
                              ),
                            );
                          },
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
