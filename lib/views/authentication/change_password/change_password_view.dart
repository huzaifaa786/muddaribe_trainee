// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors, prefer_const_literals_to_create_immutables, duplicate_ignore, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/password_inputField.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/authentication/change_password/change_password_contoller.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangepasswordController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 50),
                        child: Text(
                          'Change Password.',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: white),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // height: 300,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top:40, bottom: 25),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 15, 15, 15),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PasswordInputField(
                            lable: 'Old password',
                            obscure: controller.obscureTextOldPassword,
                            toggle: controller.toggle2,
                            controller: controller.oldpassword,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          PasswordInputField(
                            lable: 'New password',
                            obscure: controller.obscureTextPassword,
                            toggle: controller.toggle,
                            controller: controller.newpassword,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          PasswordInputField(
                            lable: 'Confirm New Password',
                            obscure: controller.obscureTextCPassword,
                            toggle: controller.toggle1,
                            controller: controller.confirmPassword,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     SvgPicture.asset('assets/images/Vector (1).svg'),
                          //     SizedBox(
                          //       width: 5,
                          //     ),
                          //     Text(
                          //       'Password Updated Successfully',
                          //       style: TextStyle(color: Colors.green),
                          //     ),
                          //   ],
                          // ),
                        ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GradientButton(
                    title: 'Submit',
                      onPressed: controller.areFieldsFilled.value
                          ? () {
                              controller.changePassword();
                            }
                          : () {
                              UiUtilites.errorSnackbar('Fill out all fields',
                                  'Please fill all above fields');
                            },
                      selected: controller.areFieldsFilled.value,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
