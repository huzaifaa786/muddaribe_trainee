// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class UiUtilites {
  static errorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: white,
      backgroundGradient: const LinearGradient(
        colors: [Colors.red, Colors.redAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static successSnackbar(String message, String title) {
    Get.snackbar(
      title,
      message,
      backgroundGradient: const LinearGradient(
        colors: [borderDown, borderTop],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      colorText: white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static successAlert(context, title) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            Get.back();
          });
          return AlertDialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.transparent, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.withOpacity(0.01)
                    : lightbgColor,
                boxShadow: [
                  Get.isDarkMode
                      ? BoxShadow(
                          blurRadius: 20,
                          offset: Offset(12, 15),
                          color: Colors.black)
                      : BoxShadow(
                          blurRadius: 0,
                          offset: Offset(0, 0),
                          color: Colors.white),
                  Get.isDarkMode
                      ? BoxShadow(
                          blurRadius: 20,
                          offset: Offset(12, -15),
                          color: Colors.black)
                      : BoxShadow(
                          blurRadius: 0,
                          offset: Offset(0, 0),
                          color: Colors.white),
                  Get.isDarkMode
                      ? BoxShadow(
                          blurRadius: 20,
                          offset: Offset(-12, 15),
                          color: Colors.black)
                      : BoxShadow(
                          blurRadius: 0,
                          offset: Offset(0, 0),
                          color: Colors.white),
                  Get.isDarkMode
                      ? BoxShadow(
                          blurRadius: 20,
                          offset: Offset(-12, -15),
                          color: Colors.black)
                      : BoxShadow(
                          blurRadius: 0,
                          offset: Offset(0, 0),
                          color: Colors.white)
                ],
                border: GradientBoxBorder(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Gap(40),
                  Image.asset('assets/images/Approve_Badge.png',
                      height: 50, width: 50),
                  Gap(10),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Get.isDarkMode ? Colors.white : black,
                      // height: 52 / 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(40),
                ],
              ),
            ),
          );
        });
  }
}
