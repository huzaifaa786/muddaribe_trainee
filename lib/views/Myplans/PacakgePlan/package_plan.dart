import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/order_api.dart';
import 'package:mudarribe_trainee/components/basic_loader.dart';
import 'package:mudarribe_trainee/components/exercises_card.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/combined_file.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/Myplans/PacakgePlan/package_controller.dart';

class PackagePlans extends StatefulWidget {
  const PackagePlans({super.key});

  @override
  State<PackagePlans> createState() => _PackagePlansState();
}

class _PackagePlansState extends State<PackagePlans> {
  // var orderId = Get.parameters['orderId'] as String;
  var category = Get.parameters['category'] as String;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagePlanController>(
      initState: (state) async {
        Future.delayed(const Duration(milliseconds: 100), () {
          // state.controller!.orderId = orderId;
          state.controller!.category = category;

          setState(() {});
        });
      },
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          centerTitle: true,
          title: TopBar(text: controller.category.capitalize!.tr),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: FutureBuilder<List<CombinedTraineeFileData>>(
                future: OrderApi.getPlansByOrder(controller.category),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: Get.height * 0.7,
                      child: BasicLoader(
                        background: false,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('');
                  }
                  if (!snapshot.hasData) {
                    return Text('');
                  }
                  List<CombinedTraineeFileData> plans = snapshot.data!;
                  return snapshot.data!.isEmpty
                      ? SizedBox(
                          height: Get.height * 0.8,
                          child: Center(
                              child: Text('No Plan File Found Yet'.tr,
                                  style: TextStyle(color: white))),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: plans.length,
                              itemBuilder: (context, index) {
                                return ExercisesCard(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.planFiles,
                                          parameters: {
                                            'planId': plans[index].plan.id,
                                            'planName': plans[index].plan.name!,
                                            'trainerId':
                                                plans[index].plan.trainerId!,
                                          });
                                    },
                                    trainerName:  plans[index].trainer.name,
                                    trainerImage: plans[index].trainer.profileImageUrl,
                                    title: plans[index].plan.name!,
                                    description:
                                        plans[index].plan.description!);
                              }),
                        );
                }),
          ),
        )),
      ),
    );
  }
}
