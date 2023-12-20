import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/auth_api.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class ChangepasswordController extends GetxController {
  static ChangepasswordController instance = Get.find();

  String selected = '';
  bool obscureTextOldPassword = true;
  bool obscureTextPassword = true;
  bool obscureTextCPassword = true;
  RxBool areFieldsFilled = false.obs;
  final _authApi = AuthApi();

  TextEditingController newpassword = TextEditingController();
  TextEditingController oldpassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  void toggle() {
    obscureTextPassword = !obscureTextPassword;
    update();
  }

  void toggle1() {
    obscureTextCPassword = !obscureTextCPassword;
    update();
  }

  void toggle2() {
    obscureTextOldPassword = !obscureTextOldPassword;
    update();
  }

  @override
  void onInit() {
    newpassword.addListener(() {
      checkFields();
    });
    oldpassword.addListener(() {
      checkFields();
    });
    confirmPassword.addListener(() {
      checkFields();
    });
    super.onInit();
  }

  void checkFields() {
    if (newpassword.text.isNotEmpty &&
        oldpassword.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty) {
      areFieldsFilled.value = true;
      update();
    } else {
      areFieldsFilled.value = false;
      update();
    }
  }

  Future changePassword() async {
    // busyController.setBusy(true);
    if (newpassword.text != confirmPassword.text) {
      UiUtilites.successSnackbar('Passwords are not similar', 'Password');
    } else {
      final response =
          await _authApi.verifyOldPassword(oldpassword.text, newpassword.text);
      print(response);
      if (response == 0) {
      } else if (response == 2) {
        UiUtilites.errorSnackbar('Provide correct old password', 'Password');
      } else if (response == 3) {
        oldpassword.clear();
        newpassword.clear();
        confirmPassword.clear();

        UiUtilites.successSnackbar('Password has been updated', 'Password');
      }
    }
    // busyController.setBusy(false);
  }
}
