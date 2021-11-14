import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

var uuid = Uuid();
// 2. compress file and get file.
Future<File?> testCompressAndGetFile(File file, String targetPath) async {
  String dir = path.dirname(file.path);
  String newPath = path.join(dir, uuid.v1());
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    newPath,
    quality: 88,
  );

  return result;
}

Future<File?> pickImage() async {
  final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
