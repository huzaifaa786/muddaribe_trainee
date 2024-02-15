// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/api/package_api.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/package_data_combined.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/trainer/packages_checkout/package_checkout_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class PackagecheckoutView extends StatefulWidget {
  const PackagecheckoutView({super.key});

  @override
  State<PackagecheckoutView> createState() => _PackagecheckoutViewState();
}

enum packagePaymentMethod { visa, googlePay, applePay }

class _PackagecheckoutViewState extends State<PackagecheckoutView> {
  @override
  Widget build(BuildContext context) {
    String packageId = Get.arguments;

    return GetBuilder<Packagecheckoutcontroller>(
        initState: (state) {
          Future.delayed(Duration(milliseconds: 100), () {
            state.controller!.packageId = packageId;
            setState(() {});
          });
        },
        builder: (controller) => Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: TopBar(text: 'Package Check out'.tr)),
              body: SafeArea(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: SingleChildScrollView(
                    child: FutureBuilder<CombinedPackageData?>(
                        future:
                            PackageApi.fetchPackageData(controller.packageId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('');
                          }
                          if (!snapshot.hasData) {
                            return Text('');
                          }
                          CombinedPackageData combinedPackagetData =
                              snapshot.data!;
                          controller.price =
                              combinedPackagetData.package.price!;

                          return Column(
                            children: [
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Container(
                                  height: 191,
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode ? bgContainer : grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    AppRoutes.trainerprofile,
                                                    arguments:
                                                        combinedPackagetData
                                                            .trainer.id);
                                              },
                                              child: ClipOval(
                                                child: Container(
                                                  width: 36,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border:
                                                        const GradientBoxBorder(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(255,
                                                              184, 66, 186),
                                                          Color.fromARGB(255,
                                                              111, 127, 247),
                                                        ],
                                                      ),
                                                      width: 2,
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          combinedPackagetData
                                                              .trainer
                                                              .profileImageUrl),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, left: 10.4),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.toNamed(
                                                              AppRoutes
                                                                  .trainerprofile,
                                                              arguments:
                                                                  combinedPackagetData
                                                                      .trainer
                                                                      .id);
                                                        },
                                                        child: Text(
                                                          combinedPackagetData
                                                              .trainer.name,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Get.width * 0.5,
                                                        child: Text(
                                                          combinedPackagetData
                                                              .trainer.category
                                                              .join('& '),
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 7,
                                                                bottom: 7),
                                                        child: combinedPackagetData
                                                                    .package
                                                                    .category ==
                                                                "nutrition"
                                                            ? Image.asset(
                                                                'assets/images/packageplanimage1.png',
                                                                height: 18,
                                                                width: 20)
                                                            : combinedPackagetData
                                                                        .package
                                                                        .category ==
                                                                    'excercise'
                                                                ? Image.asset(
                                                                    'assets/images/packageplanimage.png',
                                                                    height: 19,
                                                                    width: 20,
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/images/packageplanimage.png',
                                                                        height:
                                                                            19,
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          '+',
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      Image.asset(
                                                                          'assets/images/packageplanimage1.png',
                                                                          height:
                                                                              18,
                                                                          width:
                                                                              20),
                                                                    ],
                                                                  ),
                                                      ),
                                                      Text(
                                                        combinedPackagetData
                                                            .package.name
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 5,
                                                                bottom: 10),
                                                        child: Text(
                                                            combinedPackagetData
                                                                .package
                                                                .discription
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                right: 14,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    combinedPackagetData
                                                        .package.price
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    'AED'.tr,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Get.isDarkMode ? bgContainer : grey.withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Promo Code'.tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        controller.total != ''
                                            ? GradientText1(
                                                text: controller.promoCode.text,
                                              )
                                            : controller.isCode
                                                ? Row(
                                                    children: [
                                                      Container(
                                                          height: 35,
                                                          width: 110,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color:  Get.isDarkMode
                                                                      ? Colors
                                                                          .grey
                                                                      : white),
                                                          child: TextField(
                                                            controller:
                                                                controller
                                                                    .promoCode,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            decoration: InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                fillColor:
                                                                    Get.isDarkMode ? Colors.grey : white,
                                                                focusColor:
                                                                    Get
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .grey
                                                                    : white),
                                                          )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            controller
                                                                .applyPromoCode(
                                                                    combinedPackagetData
                                                                        .trainer
                                                                        .id);
                                                          },
                                                          child: GradientText1(
                                                            text: 'Apply'.tr,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      controller.isCode = true;
                                                      setState(() {});
                                                    },
                                                    child: GradientText1(
                                                      text: 'Add Code'.tr,
                                                    ),
                                                  )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 35, left: 5, bottom: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      'Summary'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 216,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode ? bgContainer : grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Price'.tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${combinedPackagetData.package.price} ' +
                                                'AED'.tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Divider(
                                        thickness: 1,
                                        color: dividercolor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Offer'.tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${controller.discount.toString()} ' +
                                                'AED'.tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Divider(
                                        thickness: 1,
                                        color: dividercolor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total'.tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          GradientText(
                                            controller.total == ''
                                                ? controller.price +
                                                    ' ' +
                                                    'AED'.tr
                                                : controller.total +
                                                    ' ' +
                                                    'AED'.tr,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            colors: [borderTop, gradientblue],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 30, top: 30, left: 20, right: 20),
                                child: Obx(
                                  () => GestureDetector(
                                      onTap: () {
                                        // controller.toggleButtonColor();
                                        String uid = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        String orderId = DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString();

                                        controller.payPackageCharges(
                                            combinedPackagetData.trainer.id,
                                            uid,
                                            orderId,
                                            combinedPackagetData
                                                .trainer.firebaseToken
                                                .toString());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: 17),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 55,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(5),
                                            gradient: LinearGradient(
                                              begin: Alignment(1.00, -0.03),
                                              end: Alignment(-1, 0.03),
                                              colors: controller
                                                      .isButtonPressed.value
                                                  ? [bgContainer, bgContainer]
                                                  : [
                                                      Color(0xFF58E0FF),
                                                      Color(0xFF727DCD)
                                                    ],
                                            )),
                                        child: Text(
                                          'Check Out'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          );
                        }),
                  ),
                ),
              )),
            ));
  }
}
