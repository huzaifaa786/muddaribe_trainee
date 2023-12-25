// ignore_for_file: unused_field

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/auth_api.dart';
import 'package:mudarribe_trainee/exceptions/auth_api_exception.dart';
import 'package:mudarribe_trainee/helper/loading_helper.dart';
import 'package:mudarribe_trainee/models/app_user.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/services/notification_service.dart';
import 'package:mudarribe_trainee/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class SignInController extends GetxController {
  static SignInController instance = Get.find();
  final BusyController busyController = Get.find();
  final _authApi = AuthApi();
  final _userService = UserService();
  final notificationService = NotificationService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool areFieldsFilled = false.obs;
  bool obscureTextPassword = true;

  // Input Toggle button function
  void toggle() {
    obscureTextPassword = !obscureTextPassword;
    update();
  }

  // Check all inputs are filled or not
  void checkFields() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      areFieldsFilled.value = true;
    } else {
      areFieldsFilled.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      checkFields();
    });
    passwordController.addListener(() {
      checkFields();
    });
  }

  Future signInTrainee() async {

  

    busyController.setBusy(true);
    try {
      final User user = await _authApi.loginWithEmail(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user.uid.isNotEmpty) {
        AppUser? appUser = await _userService.getAuthUser();

        if (appUser != null && appUser.userType == 'trainee') {
              var token = await FirebaseMessaging.instance.getToken();
          await _userService.syncOrCreateUser(
            user: AppUser(
                id: user.uid,
                userType: 'trainee',
                email: user.email,
                name: user.displayName,firebaseToken: token),
          );

          Get.offNamed(AppRoutes.footer);
        } else {
          UiUtilites.errorSnackbar(
              'Invalid Credentials', 'Please Provide Correct Credentials');
        }
      }
    } on AuthApiException catch (e) {
      UiUtilites.errorSnackbar('Signin Failed', e.toString());
    }
    busyController.setBusy(false);
  }

  Future signInGoogle() async {
    try {
      final User user = await _authApi.signInWithGoogle();

      if (user.uid.isNotEmpty) {
           var token = await FirebaseMessaging.instance.getToken();
        await _userService.syncOrCreateUser(
          user: AppUser(
              id: user.uid,
              userType: 'trainee',
              email: user.email,
              name: user.displayName,firebaseToken: token),
        );

        Get.offNamed(AppRoutes.footer);
      }
    } on AuthApiException catch (e) {
      UiUtilites.errorSnackbar('Signin Failed', e.toString());
    }
  }
}
