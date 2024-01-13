import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/order_api.dart';
import 'package:mudarribe_trainee/components/basic_loader%20copy.dart';
import 'package:mudarribe_trainee/components/exercises_card.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/plan.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/views/Myplans/PacakgePlan/package_controller.dart';

class PackagePlans extends StatefulWidget {
  const PackagePlans({super.key});

  @override
  State<PackagePlans> createState() => _PackagePlansState();
}

class _PackagePlansState extends State<PackagePlans> {
  var orderId = Get.parameters['orderId'] as String;
  var category = Get.parameters['category'] as String;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagePlanController>(
      initState: (state) async {
        Future.delayed(const Duration(milliseconds: 100), () {
          state.controller!.orderId = orderId;
          state.controller!.category = category;

          setState(() {});
        });
      },
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          centerTitle: true,
          title: TopBar(text: controller.category.capitalize!),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: FutureBuilder<List<Plan>>(
                future: OrderApi.getPlansByOrder(
                    controller.orderId, controller.category),
                builder: (context, snapshot) {
                     if(snapshot.connectionState == ConnectionState.waiting){
                    return SizedBox(
                      height: Get.height*0.7,
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
                  List<Plan> plans = snapshot.data!;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: plans.length,
                        itemBuilder: (context, index) {
                          return ExercisesCard(
                              onTap: () {
                                Get.toNamed(AppRoutes.planFiles, parameters: {
                                  'planId': plans[index].id,
                                  'planName': plans[index].name!,
                                  'trainerId': plans[index].trainerId!,
                                });
                              },
                              title: plans[index].name!,
                              description: plans[index].description!);
                        }),
                  );
                }),
          ),
        )),
      ),
    );
  }
}
