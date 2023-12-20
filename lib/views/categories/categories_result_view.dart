// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/trainer_saved.dart';
import 'package:mudarribe_trainee/components/boxing_trainers_card.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/categories/categories_result_%20controller.dart';

// import 'package:mudarribe_trainee/components/topbar.dart';

class CategoriesResultView extends StatefulWidget {
  const CategoriesResultView({super.key});

  @override
  State<CategoriesResultView> createState() => _CategoriesResultViewState();
}

class _CategoriesResultViewState extends State<CategoriesResultView> {
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
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          title: TopBar(
            text: args.category,
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
                              color: white.withOpacity(0.3),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                      )
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "${controller.trainersList.length.toString()} Results",
                            style: TextStyle(
                              color: white.withOpacity(0.3),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                controller.trainersList.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        alignment: Alignment.center,
                        child: Text(
                          'No Trainer With This Category Exist.',
                          style: TextStyle(color: white.withOpacity(0.5)),
                        ))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: controller.trainersList.length,
                        itemBuilder: (context, index) {
                          return BoxingTrainersCard(
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
                                controller.trainersList[index].isSaved == false
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
    );
  }
}

class MyArguments {
  final String category;

  MyArguments(this.category);
}
