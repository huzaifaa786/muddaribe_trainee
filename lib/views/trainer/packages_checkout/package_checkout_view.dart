// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/api/package_api.dart';
import 'package:mudarribe_trainee/components/Eventcheckoutcontainer.dart';
import 'package:mudarribe_trainee/components/checkbox.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:mudarribe_trainee/models/package_data_combined.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/trainer/event_checkout/event_checkout_view.dart';
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
                backgroundColor: Colors.black,
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: white,
                  ),
                ),
                title: Text(
                  'Package Check out',
                  style: TextStyle(
                      fontSize: 20,
                      color: white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins'),
                ),
              ),
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
                              Container(
                                height: 191,
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: bgContainer,
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
                                          ClipOval(
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: const GradientBoxBorder(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 184, 66, 186),
                                                      Color.fromARGB(
                                                          255, 111, 127, 247),
                                                    ],
                                                  ),
                                                  width: 2,
                                                ),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/profile.jpg'),
                                                  fit: BoxFit.contain,
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      combinedPackagetData
                                                          .trainer.name,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      combinedPackagetData
                                                          .trainer.category
                                                          .join('& '),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white
                                                            .withOpacity(
                                                                0.6000000238418579),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                                    Image.asset(
                                                                      'assets/images/packageplanimage.png',
                                                                      height:
                                                                          19,
                                                                      width: 20,
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
                                                                            color:
                                                                                white,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w700),
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
                                                              FontWeight.w700,
                                                          color:
                                                              whitewithopacity1),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                                      .w600,
                                                              color:
                                                                  whitewithopacity1)),
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  'AED',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 67,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: bgContainer,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Promo Code',
                                          style: TextStyle(
                                            color: white,
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
                                                                  color: Colors
                                                                      .black),
                                                          child: TextField(
                                                            controller:
                                                                controller
                                                                    .promoCode,
                                                            style: TextStyle(
                                                                color: white),
                                                            decoration: InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                fillColor:
                                                                    Colors
                                                                        .black,
                                                                focusColor:
                                                                    Colors
                                                                        .black),
                                                          )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            controller
                                                                .applyPromoCode(combinedPackagetData.trainer.id);
                                                          },
                                                          child: GradientText1(
                                                            text: 'Apply',
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
                                                      text: 'Add Code',
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
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Summary',
                                    style: TextStyle(
                                      color: white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 216,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: bgContainer,
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
                                            'Price ',
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${combinedPackagetData.package.price} AED',
                                            style: TextStyle(
                                              color: white,
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
                                            'Offer ',
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${controller.discount.toString()} AED',
                                            style: TextStyle(
                                              color: white,
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
                                            'Total',
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          GradientText(
                                            controller.total == ''
                                                ? controller.price + ' AED'
                                                : controller.total + ' AED',
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
                                            orderId);
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
                                          'Check Out',
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
