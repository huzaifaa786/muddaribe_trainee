// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/profile_tile.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/trainee_profile/profile/profile_controller.dart';

class TraineeProfileView extends StatelessWidget {
  const TraineeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        autoRemove: false,
        builder: (controller) => controller.currentUser != null
            ? Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  forceMaterialTransparency: true,
                  centerTitle: true,
                  title: Text(
                    'Account',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      controller.currentUser!.imageUrl == null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.asset(
                                                'assets/images/cardimg1.png',
                                                fit: BoxFit.cover,
                                                height: 90,
                                                width: 90,
                                              ))
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                imageUrl: controller
                                                    .currentUser!.imageUrl
                                                    .toString(),
                                                fit: BoxFit.cover,
                                                height: 90,
                                                width: 90,
                                              )),
                                      Text(
                                        controller.currentUser!.name!,
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: white,
                                          height: 52 / 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Divider(color: white.withOpacity(0.45)),
                                      Gap(16),
                                      ProfileTile(
                                        img: 'assets/images/person.svg',
                                        ontap: () {
                                          Get.toNamed(AppRoutes.editProfile)!
                                              .then((value) =>
                                                  controller.getAppUser());
                                        },
                                        text: 'Account Setting',
                                      ),
                                      ProfileTile(
                                        img: 'assets/images/saved.svg',
                                        ontap: () {
                                          Get.toNamed(AppRoutes.saved);
                                        },
                                        text: 'Saved',
                                      ),
                                      ProfileTile(
                                        img: 'assets/images/report.svg',
                                        ontap: () {
                                          Get.toNamed(AppRoutes.reports);
                                        },
                                        text: 'Report a problem',
                                      ),
                                      ProfileTile(
                                        img: 'assets/images/order.svg',
                                        ontap: () {},
                                        text: 'Order History',
                                      ),
                                      ProfileTile(
                                        img: 'assets/images/logout.svg',
                                        ontap: () {
                                          controller.logout();
                                        },
                                        text: 'Logout',
                                        logout: true,
                                      ),
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
