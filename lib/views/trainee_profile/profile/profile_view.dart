// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/profile_tile.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/trainee_profile/app_theme/theme.dart';
import 'package:mudarribe_trainee/views/trainee_profile/profile/profile_controller.dart';
import 'package:mudarribe_trainee/views/trainee_profile/app_translate/translate.dart';

class TraineeProfileView extends StatefulWidget {
  const TraineeProfileView({super.key});

  @override
  State<TraineeProfileView> createState() => _TraineeProfileViewState();
}

class _TraineeProfileViewState extends State<TraineeProfileView> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser == null) {
      Future.delayed(Duration.zero, () {
        setState(() {
          Get.toNamed(AppRoutes.signin)!.then((value) {
            Get.offAllNamed(AppRoutes.footer);
            ;
          });
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Container()
        : GetBuilder<ProfileController>(
            autoRemove: false,
            builder: (controller) => controller.currentUser != null
                ? Scaffold(
                    body: Column(
                      children: [
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(4292214271),
                                  Color(4288538110),
                                  Color(4289505535),
                                  Color(4289494015),
                                  Color(4289494015),
                                  Color(4289491966),
                                  Color(4289491966),
                                  // Color(4289494015),
                                ]),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: Text(
                                  'Account'.tr,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 45,
                                backgroundColor:
                                    white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(45),
                                  child: controller.currentUser!.imageUrl == ''
                                      ? Image.asset(
                                          'assets/images/dummyUser.png',
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              controller.currentUser!.imageUrl!,
                                          height: 90,
                                          width: 90,
                                                              fit: BoxFit.cover,

                                        ),
                                ),
                              ),
                              Text(
                                controller.currentUser!.name!,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 52 / 16,
                                  color: white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    // width: double.infinity,
                                    // margin: const EdgeInsets.only(
                                    //     left: 15, right: 15, top: 20, bottom: 30),
                                    // padding: const EdgeInsets.only(
                                    //     left: 15, right: 15, top: 10, bottom: 10),
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   color: Get.isDarkMode
                                    //       ? Color(0xFF0F0F0F)
                                    //       : lightbgColor,
                                    // ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Divider(
                                        //     color: Get.isDarkMode
                                        //         ? white.withOpacity(0.45)
                                        //         : grey),
                                        // Gap(16),
                                        ProfileTile(
                                          img: 'assets/images/person.svg',
                                          ontap: () {
                                            Get.toNamed(AppRoutes.editProfile)!
                                                .then((value) =>
                                                    controller.getAppUser());
                                          },
                                          text: 'Account Setting'.tr,
                                        ),
                                        ProfileTile(
                                          img: 'assets/images/saved.svg',
                                          ontap: () {
                                            Get.toNamed(AppRoutes.saved);
                                          },
                                          text: 'Saved'.tr,
                                        ),
                                        ProfileTile(
                                          img: 'assets/images/theme.svg',
                                          ontap: () {
                                            Get.to(() => ThemeScreen());
                                          },
                                          text: 'Theme'.tr,
                                        ),
                                        ProfileTile(
                                          img: 'assets/images/lang1.svg',
                                          ontap: () {
                                            Get.to(() => TranslateScreen());
                                          },
                                          text: 'Languages'.tr,
                                        ),
                                        ProfileTile(
                                          img: 'assets/images/report.svg',
                                          ontap: () {
                                            Get.toNamed(AppRoutes.reports);
                                          },
                                          text: 'Report a problem'.tr,
                                        ),
                                        ProfileTile(
                                          img: 'assets/images/order.svg',
                                          ontap: () {
                                            Get.toNamed(AppRoutes.orderHistory);
                                          },
                                          text: 'Orders History'.tr,
                                        ),
                                        ProfileTile(
                                          img: 'assets/images/logout.svg',
                                          ontap: () {
                                            UiUtilites.confirmAlert(
                                              context,
                                              "Are you sure you want to logout?"
                                                  .tr,
                                              () {
                                                controller.logout();
                                              },
                                              () {
                                                Get.back();
                                              },
                                              "Log Out".tr,
                                              "Cancel".tr,
                                            );
                                          },
                                          text: 'Log Out'.tr,
                                          logout: true,
                                        ),
                                        Gap(30)
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
                  )
                : Text(''));
  }
}

// Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Name",
//                       style: TextStyle(
//                         fontFamily: "Montserrat",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: white.withOpacity(0.45),
//                         height: 20 / 14,
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Email",
//                       style: TextStyle(
//                         fontFamily: "Montserrat",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: white.withOpacity(0.45),
//                         height: 40 / 14,
//                       ),
//                     ),
//                   ),
