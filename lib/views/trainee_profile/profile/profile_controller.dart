import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/api/auth_api.dart';
import 'package:mudarribe_trainee/exceptions/auth_api_exception.dart';
import 'package:mudarribe_trainee/models/app_user.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/services/user_service.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();
  final _authApi = AuthApi();
  AppUser? currentUser;
  final _userService = UserService();
  @override
  void onInit() {
    super.onInit();
    getAppUser();
  }

  Future getAppUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUser = await _userService.getAuthUser();
      update();
    }
  }

  Future logout() async {
    try {
      await _authApi.logout();
          Get.updateLocale(const Locale('en', 'US'));
    GetStorage box = GetStorage();
    await box.write('locale', 'en');
    box.read('locale');
      // GetStorage box = GetStorage();
      // await box.write('Locale', 'en');
      // GoogleTranslatorController.init(
      //     'AIzaSyBOr3bXgN2bj9eECzSudyj_rgIFjyXkdn8', Locale('ur'),
      //     cacheDuration: Duration(), translateTo: Locale('en'));
      Get.offAllNamed(AppRoutes.signin);
    } on AuthApiException catch (e) {
      UiUtilites.errorSnackbar('Logout Failed'.tr, e.toString());
    }
  }
}
