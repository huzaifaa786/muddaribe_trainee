// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
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
            'My Plans',
            style: TextStyle(
                fontSize: 20,
                color: white,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins'),
          ).translate(),
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
                        'Exercises',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: white),
                      ).translate(),
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
                        'Nutrition',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: white),
                      ).translate(),
                    ],
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            Plancontainer(
              onButtonTap: () {
                Get.toNamed(AppRoutes.mypackages, parameters: {
                  "category": "excercise",
                });
              },
              viewcontent: AppRoutes.mypackages,
              planimage: Image.asset(
                'assets/images/exerciseplans.png',
                fit: BoxFit.fill,
              ),
              mytext: 'Exercise Plan',
            ),
            Plancontainer(
              onButtonTap: () {
                    Get.toNamed(AppRoutes.mypackages, parameters: {
                  "category": "nutrition",
                });
              },
              viewcontent: AppRoutes.mypackages,
              planimage: Image.asset(
                'assets/images/nutritionplan.png',
                fit: BoxFit.fill,
              ),
              mytext: 'Nutrition Plan',
            ),
          ],
        ),
      ),
    );
  }
}
