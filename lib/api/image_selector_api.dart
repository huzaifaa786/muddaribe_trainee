import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class ImageSelectorApi {
  final picker = ImagePicker();

selectImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      UiUtilites.errorSnackbar('Image selection failed', 'Failed to select image, please try again.');
      // throw ImageSelectorApiException(
      //   title: 'Image selection failed',
      //   message: 'Failed to select image, please try again.',
      // );
    }
  }
}
