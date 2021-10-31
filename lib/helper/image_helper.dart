import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Future<File?> pickImage() async {
  final XFile? pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile == null) {
    return null;
  }
  final File imageFileFromLibrary = File(pickedFile.path);

  // Start crop iamge then take the file.
  File? croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFileFromLibrary.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: accentColor,
        toolbarWidgetColor: Colors.white,
        activeControlsWidgetColor: accentColor,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));

  return croppedFile;
}

Future<List<AssetEntity>?> pickMultiImage({
  required BuildContext context,
  required List<AssetEntity>? selectedAssets,
  int maxAssets = 4,
}) async {
  final List<AssetEntity>? assets = await AssetPicker.pickAssets(
    context,
    maxAssets: maxAssets,
    selectedAssets: selectedAssets,
    themeColor: accentColor,
  );
  return assets;
}
