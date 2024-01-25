// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/components/underline_input.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/trainee_profile/edit_profile/editprofile_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class TraineeEditProfileView extends StatefulWidget {
  const TraineeEditProfileView({super.key});

  @override
  State<TraineeEditProfileView> createState() => _TraineeEditProfileViewState();
}

class _TraineeEditProfileViewState extends State<TraineeEditProfileView> {
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileContoller>(
      builder: (controller) => controller.currentUser != null
          ? Directionality(
              textDirection: box.read('locale') == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                appBar: AppBar(
                    forceMaterialTransparency: true,
                    automaticallyImplyLeading: false,
                    title: TopBar(text: 'Account'.tr)),
                body: SafeArea(
                  child: Column(
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 20, bottom: 30),
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: bgContainer,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 115,
                                        width: 115,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          fit: StackFit.expand,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/dummyUser.png"),
                                            ),
                                            // Positioned(
                                            //     bottom: 23,
                                            //     right: 17,
                                            //     child: RawMaterialButton(
                                            //       onPressed: () {
                                            //         controller
                                            //             .selectProfileImage();
                                            //       },
                                            //       elevation: 2.0,
                                            //       // fillColor: Color(0xFFF5F6F9),
                                            //       // ignore: sort_child_properties_last
                                            //       child:
                                            //           controller.profileImage !=
                                            //                   null
                                            //               ? Text('')
                                            //               : Icon(
                                            //                   Icons
                                            //                       .camera_alt_outlined,
                                            //                   color: Colors.blue,
                                            //                   size: 39,
                                            //                 ),
                                            //       padding: EdgeInsets.all(15.0),
                                            //       shape: CircleBorder(),
                                            //     )),
                                          ],
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text(
                                      //     'Choose from library',
                                      //     style: TextStyle(color: white),
                                      //   ),
                                      // ),
                                      Divider(color: white.withOpacity(0.04)),
                                      Gap(16),
                                      Row(
                                        children: [
                                          Text(
                                            "User name".tr,
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: white.withOpacity(0.45),
                                              height: 20 / 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      UnderlineInputField(
                                        img: 'assets/images/person.svg',
                                        controller: controller.nameController,
                                      ),
                                      Gap(20),
                                      Row(
                                        children: [
                                          Text(
                                            "Email".tr,
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: white.withOpacity(0.45),
                                            ),
                                          ),
                                        ],
                                      ),
                                      UnderlineInputField(
                                        img: 'assets/images/email_outline.svg',
                                        controller: controller.emailController,
                                        readOnly: true,
                                      ),
                                      Gap(25),
                                      controller.providerNames!
                                              .contains('password')
                                          ? GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    AppRoutes.changepassword);
                                              },
                                              child: Row(
                                                children: [
                                                  GradientText(
                                                      'Change password?'.tr,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily:
                                                              "Poppins"),
                                                      colors: [
                                                        borderDown,
                                                        borderTop
                                                      ]),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Gap(40),
                                      GradientButton(
                                          title: 'Save'.tr,
                                          onPressed: () {
                                            controller.updateTrainee();
                                          },
                                          selected: true),
                                      Gap(15)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
