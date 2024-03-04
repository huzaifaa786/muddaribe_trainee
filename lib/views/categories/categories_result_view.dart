// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/api/trainer_saved.dart';
import 'package:mudarribe_trainee/components/boxing_trainers_card.dart';
import 'package:mudarribe_trainee/components/loading_indicator.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/categories/categories_result_%20controller.dart';

// import 'package:mudarribe_trainee/components/topbar.dart';

class CategoriesResultView extends StatefulWidget {
  const CategoriesResultView({super.key});

  @override
  State<CategoriesResultView> createState() => _CategoriesResultViewState();
}

class _CategoriesResultViewState extends State<CategoriesResultView> {
  GetStorage box = GetStorage();
  final args = Get.arguments as MyArguments;
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
          body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  controller.trainersList.isEmpty
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${controller.trainersList.length.toString()} " +
                                      "Results".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/images/arrow-sort.svg',
                                  color: borderTop,
                                ),
                                onPressed: () async {
                                  String? selectedOption =
                                      await _showSortOptionsBottomSheet(
                                          context);
                                  if (selectedOption != null) {
                                    if (selectedOption == 'highToLow') {
                                      controller.sortTrainersByRating();
                                    } else if (selectedOption == 'lowToHigh') {
                                      controller.sortTrainersByRatingDownToUp();
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                  controller.trainersList.isEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          alignment: Alignment.center,
                          child: Text(
                            'No Trainer With This Category Exist.'.tr,
                          ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.trainersList.length,
                          itemBuilder: (context, index) {
                            return BoxingTrainersCard(
                                onProfileTap: () {
                                  Get.toNamed(AppRoutes.trainerprofile,
                                      arguments:
                                          controller.trainersList[index].id);
                                },
                                rating: controller.trainersList[index].rating,
                                title: controller.trainersList[index].name,
                                description: controller
                                    .trainersList[index].category
                                    .join('\n'),
                                imgpath1: controller
                                    .trainersList[index].profileImageUrl,
                                isSaved: controller.trainersList[index].isSaved,
                                ontap: () {
                                  controller.trainersList[index].isSaved =
                                      !controller.trainersList[index].isSaved;
                                  setState(() {});
                                  controller.trainersList[index].isSaved ==
                                          false
                                      ? TrainerSaved.trainerUnsaved(
                                          controller.trainersList[index].id)
                                      : TrainerSaved.trainerSaved(
                                          controller.trainersList[index].id);
                                });
                          },
                        ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }

  Future<String?> _showSortOptionsBottomSheet(BuildContext context) async {
    String? selectedOption = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Sort by Rating'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // tileColor: Colors.grey.shade300,
              ),
              ListTile(
                title: Text('Highest to Lowest'.tr),
                onTap: () {
                  Navigator.pop(context, 'highToLow');
                },
              ),
              ListTile(
                title: Text('Lowest to Highest'.tr),
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
}

class MyArguments {
  final String category;

  MyArguments(this.category);
}
