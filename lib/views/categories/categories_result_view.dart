// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/api/trainer_saved.dart';
import 'package:mudarribe_trainee/components/boxing_trainers_card.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/loading_indicator.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/categories/categories_result_%20controller.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';

// import 'package:mudarribe_trainee/components/topbar.dart';

class CategoriesResultView extends StatefulWidget {
  const CategoriesResultView({super.key});

  @override
  State<CategoriesResultView> createState() => _CategoriesResultViewState();
}

class _CategoriesResultViewState extends State<CategoriesResultView> {
  GetStorage box = GetStorage();
  final args = Get.arguments as MyArguments;
  Set<Languages> lang = Set<Languages>();
  Set<Gender> gender = Set<Gender>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
      initState: (state) async {
        await Future.delayed(Duration(milliseconds: 100));
        state.controller!.trainersCollection =
            FirebaseFirestore.instance.collection('users');
        state.controller!.fetchDataFromFirebase(args.category);
      },
      autoRemove: false,
      builder: (controller) => BusyIndicator(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            forceMaterialTransparency: true,
            title: TopBar(
              text: args.category.tr,
            ),
          ),
          body: SafeArea(
              child: Stack(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: controller.show == true
                    ? () {
                        controller.toggleShow();
                      }
                    : null,
                child: IgnorePointer(
                  ignoring: controller.show == true ? true : false,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Gap(8),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  style: TextStyle(
                                    color:
                                        Get.isDarkMode ? Colors.white : black,
                                    fontFamily: "Montserrat",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onChanged: (String val) {
                                    setState(() {
                                      controller.filterTrainers(val);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      fillColor: Get.isDarkMode
                                          ? bgContainer
                                          : lightbgColor,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 14),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Get.isDarkMode
                                                  ? black
                                                  : lightbgColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Get.isDarkMode
                                                  ? black
                                                  : lightbgColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      hintText: 'Search trainer by name'.tr,
                                      suffixIcon: IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/images/arrow-sort.svg',
                                          color: borderTop,
                                        ),
                                        onPressed: () async {
                                          String? selectedOption =
                                              await showSortOptionsBottomSheet(
                                                  context);
                                          if (selectedOption != null) {
                                            if (selectedOption == 'highToLow') {
                                              controller.sortTrainersByRating();
                                            } else if (selectedOption ==
                                                'lowToHigh') {
                                              controller
                                                  .sortTrainersByNameAToZ();
                                            }
                                          }
                                        },
                                      ),
                                      hintStyle: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.white.withOpacity(0.3)
                                            : black.withOpacity(.3),
                                        fontFamily: "Montserrat",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.toggleShow();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SvgPicture.asset(
                                    'assets/images/filter.svg',
                                    fit: BoxFit.scaleDown,
                                    color: Get.isDarkMode ? white : black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(8),
                        controller.serachedtrainersList.isEmpty
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: Text("",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    )),
                              )
                            : Directionality(
                                textDirection: box.read('locale') == 'ar'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        "${controller.serachedtrainersList.length.toString()} " +
                                            "Results".tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    // IconButton(
                                    //   icon: SvgPicture.asset(
                                    //     'assets/images/arrow-sort.svg',
                                    //     color: borderTop,
                                    //   ),
                                    //   onPressed: () async {
                                    //     String? selectedOption =
                                    //         await _showSortOptionsBottomSheet(
                                    //             context);
                                    //     if (selectedOption != null) {
                                    //       if (selectedOption == 'highToLow') {
                                    //         controller.sortTrainersByRating();
                                    //       } else if (selectedOption == 'lowToHigh') {
                                    //         controller.sortTrainersByRatingDownToUp();
                                    //       }
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                        controller.serachedtrainersList.isEmpty
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                alignment: Alignment.center,
                                child: Text(
                                  'No Trainer With This Category Exist.'.tr,
                                ))
                            : Flexible(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.85,
                                  child: ListView.builder(
                                    // shrinkWrap: true,
                                    // physics: BouncingScrollPhysics(),
                                    itemCount:
                                        controller.serachedtrainersList.length,
                                    itemBuilder: (context, index) {
                                      return BoxingTrainersCard(
                                          onProfileTap: () {
                                            Get.toNamed(
                                                AppRoutes.trainerprofile,
                                                arguments: controller
                                                    .serachedtrainersList[index]
                                                    .id);
                                          },
                                          rating: controller
                                              .serachedtrainersList[index]
                                              .rating,
                                          title: controller
                                              .serachedtrainersList[index].name,
                                          description: controller
                                              .serachedtrainersList[index]
                                              .category
                                              .join('\n'),
                                          imgpath1: controller
                                              .serachedtrainersList[index]
                                              .profileImageUrl,
                                          isSaved: controller
                                              .serachedtrainersList[index]
                                              .isSaved,
                                          ontap: () {
                                            controller
                                                    .serachedtrainersList[index]
                                                    .isSaved =
                                                !controller
                                                    .serachedtrainersList[index]
                                                    .isSaved;
                                            setState(() {});
                                            controller
                                                        .serachedtrainersList[
                                                            index]
                                                        .isSaved ==
                                                    false
                                                ? TrainerSaved.trainerUnsaved(
                                                    controller
                                                        .serachedtrainersList[
                                                            index]
                                                        .id)
                                                : TrainerSaved.trainerSaved(
                                                    controller
                                                        .serachedtrainersList[
                                                            index]
                                                        .id);
                                          });
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              controller.show == true
                  ? Positioned(
                      top: 65,
                      right: 20,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 6.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(15)),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              width: 200,
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Languages'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: white),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _buildLanguageCheckboxes()),
                                  Text(
                                    'Gender'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: white),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _buildGenderButtons()),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GradientButton(
                                      title: 'Search'.tr,
                                      onPressed: () async {
                                        controller.lang = lang;
                                        controller.selectedGenders = gender;
                                        controller.filterTrainers('');
                                        controller.toggleShow();
                                      },
                                      selected: true,
                                      buttonwidth: 0.3,
                                      buttonHeight: 40.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  : Container()
            ],
          )),
        ),
      ),
    );
  }

  Future<String?> showSortOptionsBottomSheet(BuildContext context) async {
    String? selectedOption = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Sort by'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // tileColor: Colors.grey.shade300,
              ),
              ListTile(
                title: Text('By rating '.tr),
                onTap: () {
                  Navigator.pop(context, 'highToLow');
                },
              ),
              ListTile(
                title: Text('By alphabets'.tr),
                onTap: () {
                  Navigator.pop(context, 'lowToHigh');
                },
              ),
            ],
          ),
        );
      },
    );

    return selectedOption;
  }

  //! Language Filteration Widget
  List<Widget> _buildLanguageCheckboxes() {
    List<Widget> checkboxes = [];
    for (Languages option in Languages.values) {
      checkboxes.add(
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                activeColor: borderTop,
                value: lang.contains(option),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      if (value) {
                        lang.add(option);
                      } else {
                        lang.remove(option);
                      }
                    }
                  });
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.32,
                child: Text(
                  option.toString().split('.').last.tr,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    color: white,
                  ),
                ),
              ),
              Text(''),
            ],
          ),
        ),
      );
    }
    return checkboxes;
  }

  //! Gender Filteration Widget
  List<Widget> _buildGenderButtons() {
    List<Widget> radioButtons = [];
    for (Gender option in Gender.values) {
      radioButtons.add(
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.0,
                child: Checkbox(
                  activeColor: borderTop,
                  value: gender.contains(option),
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          gender.add(option);
                        } else {
                          gender.remove(option);
                        }
                      }
                    });
                  },
                ),
              ),
              Text(
                option.toString().split('.').last.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: white),
              ),
              Text(
                '',
              ),
            ],
          ),
        ),
      );
    }
    return radioButtons;
  }
}

class MyArguments {
  final String category;

  MyArguments(this.category);
}
