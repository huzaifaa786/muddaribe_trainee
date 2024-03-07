import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class ImageSelectorApi {
  final picker = ImagePicker();

  selectImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      bool userConfirmed = await showConfirmationDialog(Get.context!);

      if (userConfirmed) {
        return File(pickedFile.path);
      }
    } else {
      UiUtilites.errorSnackbar('Image selection failed'.tr,
          'Failed to select image, please try again.'.tr);
    }
  }
}
