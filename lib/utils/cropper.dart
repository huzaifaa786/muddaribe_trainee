import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

final aspectRatios = [CropAspectRatioPreset.square];

uiSetting({
  required String? androidTitle,
  required String? iosTitle,
}) {
  return [
    AndroidUiSettings(
        toolbarTitle: androidTitle,
        toolbarColor: black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false),
    IOSUiSettings(
      title: iosTitle,
    ),
  ];
}
