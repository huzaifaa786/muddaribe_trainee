// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/inputfield.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/authentication/forgot_password/forgot_password_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordContoller>(
      builder: (controller) => Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios_new, color: white)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 50),
                        child: Text(
                          "Forget Password",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        height: 300,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 15, 15, 15),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Enter Your Email Please",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.45),
                                  height: 28 / 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              InputField(
                                lable: 'Email',
                                controller: controller.emailController,
                              ),
                              Text(''),
                            ]),
                      ),
                      Gap(50),
                   
                      GradientButton(
                        title: 'Next',
                        onPressed: controller.areFieldsFilled.value
                      ? () {
                          controller.forgotPassword();
                        }
                      : (){
                         UiUtilites.errorSnackbar('Fill Email Field','Please fill above email field');
                      },
                        selected: controller.areFieldsFilled.value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
