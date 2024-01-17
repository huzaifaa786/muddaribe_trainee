// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:mudarribe_trainee/components/IconButton.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/inputfield.dart';
import 'package:mudarribe_trainee/components/loading_indicator.dart';
import 'package:mudarribe_trainee/components/password_inputField.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/controller_initlization.dart';
import 'package:mudarribe_trainee/utils/translation.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/authentication/signin/signin_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String? translatedText;
  String? privacypolicy;
  String? and;
  String? term_and_condition;
  String? signup;
  String? create;
  translateText1() async {
    translatedText = await translateText('Forget password?');
    privacypolicy = await translateText('Privacy Policy');
    and = await translateText('and');
    term_and_condition = await translateText('Terms & Conditions');
    signup = await translateText('Sign Up');
    create = await translateText('Create a new account ?');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    translateText1();
  }

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
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ).translate(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Enter your registred email and\npassword to sign in!",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: white.withOpacity(0.45),
                              ),
                              textAlign: TextAlign.center,
                            ).translate(),
                          ),
                          Container(
                            height: 250,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 15, 15, 15),
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
                                            translatedText ?? '',
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
                                            'Fill out all fields',
                                            'Please fill all above fields');
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
                                    fontWeight: FontWeight.w500,
                                    color: white),
                              ).translate(),
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
                                  color: white,
                                ),
                                textAlign: TextAlign.center,
                              ).translate(),
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
                                      text: privacypolicy ?? '',
                                      // text: 'Privacy Policy',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                          color: white),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                    TextSpan(
                                      text: '  ',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    TextSpan(
                                      text: and ?? '',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    TextSpan(
                                      text: '  ',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    TextSpan(
                                      text: term_and_condition ?? '',
                                      // text: 'Terms & Conditions',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                          color: Colors.white),
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
                                      text: create,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: white),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                    TextSpan(text: '    '),
                                    TextSpan(
                                      text: signup ?? '',
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
