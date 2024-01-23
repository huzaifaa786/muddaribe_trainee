import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/order_api.dart';
import 'package:mudarribe_trainee/components/basic_loader%20copy.dart';
import 'package:mudarribe_trainee/components/exercises_card2.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/combine_order.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/views/Myplans/myPackages/my_packages_controller.dart';


class MyPackages extends StatefulWidget {
  const MyPackages({super.key});

  @override
  State<MyPackages> createState() => _MyPackagesState();
}

class _MyPackagesState extends State<MyPackages> {
  @override
  Widget build(BuildContext context) {
    var category = Get.parameters['category'] as String;
    return GetBuilder<MyPackagesController>(
      initState: (state) async {
        Future.delayed(const Duration(milliseconds: 100), () {
          state.controller!.category = category;
          setState(() {});
        });
      },
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          centerTitle: true,
          title: TopBar(text: '${controller.category.capitalize!}'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: FutureBuilder<List<CombinedOrderData>>(
                future: OrderApi.fetchTraineeOrders(category),
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
                  List<CombinedOrderData> combinedOrderData = snapshot.data!;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: combinedOrderData.length,
                        itemBuilder: (context, index) {
                          return ExercisesCard2(
                            ontap: () {
                              Get.toNamed(AppRoutes.packagePlans, parameters: {
                                "orderId": combinedOrderData[index].order.id,
                                "category":controller.category,
                              });
                            },
                            category: combinedOrderData[index]
                                .combinedPackageData!
                                .package
                                .category,
                            planName: combinedOrderData[index]
                                .combinedPackageData!
                                .package
                                .name,
                            trainerName: combinedOrderData[index]
                                .combinedPackageData!
                                .trainer
                                .name,
                            trainerProfile: combinedOrderData[index]
                                .combinedPackageData!
                                .trainer
                                .profileImageUrl,
                            trainerCategories: combinedOrderData[index]
                                .combinedPackageData!
                                .trainer
                                .category
                                .join('& '),
                          );
                        }),
                  );
                }),
          ),
        )),
      ),
    );
  }
}
