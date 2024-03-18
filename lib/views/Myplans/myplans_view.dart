// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/components/plancontainer.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class MyplansView extends StatefulWidget {
  const MyplansView({super.key});

  @override
  State<MyplansView> createState() => _MyplansViewState();
}

class _MyplansViewState extends State<MyplansView> {
  GetStorage box = GetStorage();
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
        : DefaultTabController(
            length: 2,
            // PackageType.values.length,
            child: Directionality(
              textDirection:  box.read('locale') == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'My Plans'.tr,
                    style: TextStyle(
                        fontSize: 20,
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
                              SvgPicture.asset(
                                'assets/images/dumbel.svg',
                                width: 20,
                                height: 20,
                                color: Get.isDarkMode ? white : black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Exercises'.tr,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/nutri.svg',
                                width: 20,
                                height: 20,
                                color: Get.isDarkMode ? white : black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Nutrition'.tr,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
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
                        Get.toNamed(AppRoutes.packagePlans, parameters: {
                          "orderId": '345',
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
            ),
          );
  }
}
