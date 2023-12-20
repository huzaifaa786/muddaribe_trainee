// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/auth_api.dart';
import 'package:mudarribe_trainee/exceptions/auth_api_exception.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/services/user_service.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class ForgotPasswordContoller extends GetxController {
  static ForgotPasswordContoller instance = Get.find();
  TextEditingController emailController = TextEditingController();
  RxBool areFieldsFilled = false.obs;
  final _authApi = AuthApi();
  final _userService = UserService();

  void checkFields() {
    if (emailController.text.isNotEmpty) {
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
  }

  Future forgotPassword() async {
    try {
      final bool isSent = await _authApi.forgotPassword(
        email: emailController.text,
      );
      if (isSent) {
        await UiUtilites.successSnackbar(
            'Forget Password', 'Reset password link has been sent to email');
                Get.offNamed(AppRoutes.signin);
      }
  
    } on AuthApiException catch (e) {
      UiUtilites.errorSnackbar('Forget password Failed', e.toString());
    }
  }
}
