// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/plancontainer.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class MyplansView extends StatefulWidget {
  const MyplansView({super.key});

  @override
  State<MyplansView> createState() => _MyplansViewState();
}

class _MyplansViewState extends State<MyplansView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      // PackageType.values.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'My Plans'.tr,
            style: TextStyle(
                fontSize: 20,
                color: white,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins'),
          ),
          bottom: TabBar(
              isScrollable: false,
              dividerColor: Colors.transparent,
              indicatorWeight: 0.4,
              indicatorColor: borderTop,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/excersize image.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Exercises'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: white),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/nutritionsimage.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Nutrition'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: white),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            Plancontainer(
              onButtonTap: () {
                // Get.toNamed(AppRoutes.mypackages, parameters: {
                //   "category": "excercise",
                // });
                Get.toNamed(AppRoutes.packagePlans, parameters: {
                  "orderId":'345',
                  "category": 'excercise',
                });
              },
              viewcontent: AppRoutes.mypackages,
              planimage: Image.asset(
                'assets/images/exerciseplans.png',
                fit: BoxFit.fill,
              ),
              mytext: 'Exercise Plan'.tr,
            ),
            Plancontainer(
              onButtonTap: () {
                 Get.toNamed(AppRoutes.packagePlans, parameters: {
                  "category": 'nutrition',
                });
              },
              viewcontent: AppRoutes.mypackages,
              planimage: Image.asset(
                'assets/images/nutritionplan.png',
                fit: BoxFit.fill,
              ),
              mytext: 'Nutrition Plan'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
