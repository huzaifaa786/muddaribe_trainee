import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/auth_api.dart';
import 'package:mudarribe_trainee/exceptions/auth_api_exception.dart';
import 'package:mudarribe_trainee/helper/loading_helper.dart';
import 'package:mudarribe_trainee/models/app_user.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/services/user_service.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class SignUpController extends GetxController {
  static SignUpController instance = Get.find();
  final BusyController busyController = Get.find();
  final _authApi = AuthApi();
  final _userService = UserService();

  //
  bool obscureTextPassword = true;
  bool obscureTextCPassword = true;
  void toggle() {
    obscureTextPassword = !obscureTextPassword;
    update();
  }

  void toggle1() {
    obscureTextCPassword = !obscureTextCPassword;
    update();
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool areFieldsFilled = false.obs;

  void checkFields() {
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      areFieldsFilled.value = true;
    } else {
      areFieldsFilled.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    usernameController.addListener(() {
      checkFields();
    });
    emailController.addListener(() {
      checkFields();
    });
    passwordController.addListener(() {
      checkFields();
    });
    confirmPasswordController.addListener(() {
      checkFields();
    });
  }

  Future signUpTrainee() async {
    busyController.setBusy(true);
    try {
      final User user = await _authApi.signUpWithEmail(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user.uid.isNotEmpty) {
        var token = await FirebaseMessaging.instance.getToken();
        await _userService.syncOrCreateUser(
          user: AppUser(
              id: user.uid,
              userType: 'trainee',
              email: user.email,
              name: usernameController.text,
              firebaseToken: token),
        );
        // UiUtilites.successSnackbar(
        //     'Register User', 'User registered successfully');
        Get.offNamed(AppRoutes.footer);
      }
    } on AuthApiException catch (e) {
      UiUtilites.errorSnackbar('Signup Failed', e.toString());
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
              firebaseToken: token,
              id: user.uid,
              userType: 'trainee',
              email: user.email,
              name: user.displayName),
        );

        Get.offNamed(AppRoutes.footer);
      }
    } on AuthApiException catch (e) {
      UiUtilites.errorSnackbar('Signin Failed', e.toString());
    }
  }
}
