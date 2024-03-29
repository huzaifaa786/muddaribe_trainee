// ignore_for_file: unused_field

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mudarribe_trainee/api/image_selector_api.dart';
import 'package:mudarribe_trainee/api/storage_api.dart';
import 'package:mudarribe_trainee/helper/data_model.dart';
import 'package:mudarribe_trainee/helper/loading_helper.dart';
import 'package:mudarribe_trainee/models/app_user.dart';
import 'package:mudarribe_trainee/services/user_service.dart';
import 'package:mudarribe_trainee/utils/cropper.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class EditProfileContoller extends GetxController {
  static EditProfileContoller instance = Get.find();
  final BusyController busyController = Get.find();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _imageSelectorApi = ImageSelectorApi();
  final _storageApi = StorageApi();

  final _userService = UserService();
  AppUser? currentUser;
  List<String> selectedCategories = [];
  RxBool areFieldsFilled = false.obs;
  File? profileImage;
  String? img;
  List<String>? providerNames;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      checkFields();
    });
    providerNames =
        FirebaseAuth.instance.currentUser!.providerData.map((provider) {
      return provider.providerId;
    }).toList();
    getAppUser();
  }

  Future getAppUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUser = await _userService.getAuthUser();
      nameController.text = currentUser!.name!;
      emailController.text = currentUser!.email!;
      update();
    }
  }

  Future updateTrainee() async {
    busyController.setBusy(true);
    if (profileImage != null) {
      CloudStorageResult? imageResult = await updateProfileImg(currentUser!);
      if (imageResult!.imageUrl != '') {
        await _userService.updateUser(id: currentUser!.id, user: {
          'name': nameController.text,
          'profileImageFileName': imageResult.imageFileName,
          'profileImageUrl': imageResult.imageUrl,
        });
        UiUtilites.successSnackbar(
            'Update User'.tr, 'User updated successfully'.tr);
      }
    } else {
      await _userService.updateUser(
        id: currentUser!.id,
        user: {
          'name': nameController.text,
        },
      );
      UiUtilites.successSnackbar(
          'Update User'.tr, 'User updated successfully'.tr);
    }
    busyController.setBusy(false);
  }

  Future updateProfileImg(AppUser appUser) async {
    if (profileImage != null) {
      if (currentUser!.imageUrl != '') {
        final result = await _storageApi.deleteProfileImage(
            userId: currentUser!.id, fileName: currentUser!.imageName!);
        if (result) {
          // The file existed and has been deleted, proceed to upload the new image
          final CloudStorageResult storageResult =
              await _storageApi.uploadProfileImage(
                  userId: currentUser!.id, imageToUpload: profileImage!);
          return storageResult;
        }
      }

      // If the file did not exist or deletion was not successful, proceed to upload
      final CloudStorageResult storageResult =
          await _storageApi.uploadProfileImage(
              userId: currentUser!.id, imageToUpload: profileImage!);
      return storageResult;
    }
  }

  // Future selectProfileImage() async {
  //   final tempImage = await _imageSelectorApi.selectImage();
  //   profileImage = tempImage;
  //   checkFields();
  //   update();
  // }

  Future selectProfileImage() async {
    final tempImage = await _imageSelectorApi.selectImageForCropper();
    cropImage(tempImage);
    update();
  }

  cropImage(pickedImage) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: aspectRatios,
      uiSettings: uiSetting(androidTitle: 'Crop Image', iosTitle: 'Crop Image'),
    );
    if (croppedImage != null) {
      // bool userConfirmed = await showConfirmationDialog(Get.context!);

      // if (userConfirmed) {
      profileImage = File(croppedImage.path);
      // }
    } else {
      UiUtilites.errorSnackbar('Image selection failed'.tr,
          'Failed to select image, please try again.'.tr);
    }
    checkFields();
    update();
  }

  void checkFields() {
    if (nameController.text.isNotEmpty && selectedCategories != []) {
      areFieldsFilled.value = true;
    } else {
      areFieldsFilled.value = false;
    }
  }
}
