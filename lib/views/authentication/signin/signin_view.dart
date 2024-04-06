// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/IconButton.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/inputfield.dart';
import 'package:mudarribe_trainee/components/loading_indicator.dart';
import 'package:mudarribe_trainee/components/password_inputField.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/controller_initlization.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/authentication/signin/signin_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      builder: (controller) => BusyIndicator(
        child: Scaffold(
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.71,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 50, bottom: 15),
                            child: Text(
                              "Sign in to Your account",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Enter your registred email and\npassword to sign in!",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 250,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Get.isDarkMode
                                    ? Color.fromARGB(255, 15, 15, 15)
                                    : grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InputField(
                                    lable: 'Email',
                                    controller: controller.emailController,
                                  ),
                                  PasswordInputField(
                                    obscure: controller.obscureTextPassword,
                                    toggle: controller.toggle,
                                    lable: 'Password',
                                    controller: controller.passwordController,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(AppRoutes.forgot);
                                        },
                                        child: GradientText(
                                            'Forget password?'.tr,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: "Poppins"),
                                            colors: [borderDown, borderTop]),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Obx(() {
                              return GradientButton(
                                title: 'Next',
                                onPressed: controller.areFieldsFilled.value
                                    ? () {
                                        signInController.signInTrainee();
                                      }
                                    : () {
                                        UiUtilites.errorSnackbar(
                                            'Fill out all fields'.tr,
                                            'Please fill all above fields'.tr);
                                      },
                                selected: controller.areFieldsFilled.value,
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Divider(color: borderTop))),
                              Text(
                                "Or ",
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Expanded(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Divider(color: borderDown))),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: IconButtons(
                                title: 'Sign in with Apple',
                                icon: 'assets/images/apple.png',
                                onPressed: () {},
                                gradientColors: [bgContainer, bgContainer]),
                          ),
                          IconButtons(
                              title: 'Sign in with Google',
                              icon: 'assets/images/google.png',
                              onPressed: () {
                                controller.signInGoogle();
                              },
                              textcolor: Colors.black,
                              gradientColors: [white, white]),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.only(top: 15),
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Text(
                                "By clicking “Next”,you confirm that you have read and agreed to the ",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Privacy Policy'.tr,
                                      // text: 'Privacy Policy',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                          color:
                                              Get.isDarkMode ? white : black),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                    TextSpan(
                                      text: '  ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Get.isDarkMode ? white : black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'and'.tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Get.isDarkMode ? white : black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Get.isDarkMode ? white : black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Terms & Conditions'.tr,
                                      // text: 'Terms & Conditions',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline,
                                        color: Get.isDarkMode ? white : black,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 20),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'create a new account ?'.tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        color: Get.isDarkMode ? white : black,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                    TextSpan(text: '    '),
                                    TextSpan(
                                      text: 'Sign Up'.tr,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: borderDown),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.toNamed(AppRoutes.signup);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
