import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:mudarribe_trainee/views/chat/chat_page.dart';
import 'package:mudarribe_trainee/views/chat/chat_view.dart';

class SplashController extends GetxController {
  static SplashController instance = Get.find();

  void initscreen() async {
    await Future.delayed(const Duration(seconds: 3), () {
      checkFirstSeen();
      update();
    });
  }

  Future checkFirstSeen() async {
    bool firstCall = await IsFirstRun.isFirstCall();
    if (firstCall) {
      Get.offNamed(AppRoutes.onBoarding);
    } else {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Get.offNamed(AppRoutes.footer);
      } else {
        Get.offNamed(AppRoutes.signin);
      }
    }
  }
}


