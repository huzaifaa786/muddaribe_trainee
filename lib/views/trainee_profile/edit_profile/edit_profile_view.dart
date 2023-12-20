// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/underline_input.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/trainee_profile/edit_profile/editprofile_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class TraineeEditProfileView extends StatelessWidget {
  const TraineeEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileContoller>(
      builder: (controller) => controller.currentUser != null
          ? Scaffold(
              appBar: AppBar(
                forceMaterialTransparency: true,
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: white,
                  ),
                ),
                title: Text('Account',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    )),
              ),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 115,
                                      width: 115,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        fit: StackFit.expand,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: () {
                                              if (controller.profileImage !=
                                                  null) {
                                                return Image.file(controller
                                                        .profileImage!)
                                                    .image;
                                              } else if (controller
                                                      .currentUser!.imageUrl !=
                                                  null) {
                                                return NetworkImage(controller
                                                    .currentUser!.imageUrl!);
                                              } else {
                                                return AssetImage(
                                                    "assets/images/logo.png");
                                              }
                                            }(),
                                          ),
                                          Positioned(
                                              bottom: 23,
                                              right: 17,
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  controller
                                                      .selectProfileImage();
                                                },
                                                elevation: 2.0,
                                                // fillColor: Color(0xFFF5F6F9),
                                                // ignore: sort_child_properties_last
                                                child:
                                                    controller.profileImage !=
                                                            null
                                                        ? Text('')
                                                        : Icon(
                                                            Icons
                                                                .camera_alt_outlined,
                                                            color: Colors.blue,
                                                            size: 39,
                                                          ),
                                                padding: EdgeInsets.all(15.0),
                                                shape: CircleBorder(),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Choose from library',
                                        style: TextStyle(color: white),
                                      ),
                                    ),
                                    Divider(color: white.withOpacity(0.04)),
                                    Gap(16),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: white.withOpacity(0.45),
                                          height: 20 / 14,
                                        ),
                                      ),
                                    ),
                                    UnderlineInputField(
                                      img: 'assets/images/person.svg',
                                      controller: controller.nameController,
                                    ),
                                    Gap(20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Email",
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: white.withOpacity(0.45),
                                        ),
                                      ),
                                    ),
                                    UnderlineInputField(
                                      img: 'assets/images/email_outline.svg',
                                      controller: controller.emailController,
                                      readOnly: true,
                                    ),
                                    Gap(25),
                                    GestureDetector(
                                      onTap: (){
                                        Get.toNamed(AppRoutes.changepassword);
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: GradientText('Change password?',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: "Poppins"),
                                            colors: [borderDown, borderTop]),
                                      ),
                                    ),
                                    Gap(40),
                                    GradientButton(
                                        title: 'Save',
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
            )
          : SizedBox(),
    );
  }
}
