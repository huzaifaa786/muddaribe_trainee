// ignore_for_file: unused_field

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/image_selector_api.dart';
import 'package:mudarribe_trainee/api/storage_api.dart';
import 'package:mudarribe_trainee/helper/data_model.dart';
import 'package:mudarribe_trainee/models/app_user.dart';
import 'package:mudarribe_trainee/services/user_service.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class EditProfileContoller extends GetxController {
  static EditProfileContoller instance = Get.find();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _imageSelectorApi = ImageSelectorApi();
  final _storageApi = StorageApi();

  final _userService = UserService();
  AppUser? currentUser;
  List<String> selectedCategories = [];
  RxBool areFieldsFilled = false.obs;
  File? profileImage;
  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      checkFields();
    });
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
    // busyController.setBusy(true);
    if (profileImage != null) {
      CloudStorageResult? imageResult = await updateProfileImg(currentUser!);
      if (imageResult!.imageUrl != '') {
        await _userService.updateUser(id: currentUser!.id, user: {
          'name': nameController.text,
          'profileImageFileName': imageResult.imageFileName,
          'profileImageUrl': imageResult.imageUrl,
        });
        UiUtilites.successSnackbar('Update User', 'User updated successfully');
      }
    } else {
      await _userService.updateUser(
        id: currentUser!.id,
        user: {
          'name': nameController.text,
        },
      );
      UiUtilites.successSnackbar('Update User', 'User updated successfully');
    }
    // busyController.setBusy(false);
  }

  Future updateProfileImg(AppUser appUser) async {
    if (profileImage != null) {
      if (currentUser!.imageUrl != null) {
        final result = await _storageApi.deleteProfileImage(
            userId: currentUser!.id, fileName: currentUser!.imageUrl!);
        if (result) {
          final CloudStorageResult storageResult =
              await _storageApi.uploadProfileImage(
                  userId: currentUser!.id, imageToUpload: profileImage!);
          return storageResult;
        }
      } else {
        final CloudStorageResult storageResult =
            await _storageApi.uploadProfileImage(
                userId: currentUser!.id, imageToUpload: profileImage!);
        return storageResult;
      }
    }
  }

  Future selectProfileImage() async {
    final tempImage = await _imageSelectorApi.selectImage();
    profileImage = tempImage;
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
