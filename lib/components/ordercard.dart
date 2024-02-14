// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/models/order.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_package.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class OrderCard extends StatefulWidget {
  const OrderCard({
    Key? key,
    required this.trainer,
    required this.package,
    required this.order,
  }) : super(
          key: key,
        );
  final Trainer trainer;
  final TrainerPackage package;
  final TrainerOrder order;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Container(
          height: 344,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: Get.isDarkMode ? black : grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Directionality(
                textDirection: box.read('locale') == 'ar'
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.only(left: 19, top: 19, right: 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: const GradientBoxBorder(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 184, 66, 186),
                                  Color.fromARGB(255, 111, 127, 247),
                                ],
                              ),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  widget.trainer.profileImageUrl),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 11, left: 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.trainer.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              width: Get.width * 0.63,
                              child: Text(
                                widget.trainer.category.join('& '),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 15),
                child: Container(
                  height: 201,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            height: 50,
                            width: MediaQuery.sizeOf(context).width * 0.31,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                              right: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                            )),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Package'.tr,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            height: 149,
                            width: MediaQuery.sizeOf(context).width * 0.31,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                              right: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                            )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.package.category == 'excercise&nutrition'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/packageplanimage.png',
                                            height: 19,
                                            width: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text(
                                              '+',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Image.asset(
                                              'assets/images/packageplanimage1.png',
                                              height: 18,
                                              width: 20),
                                        ],
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, bottom: 10),
                                        child: widget.package.category ==
                                                'excercise'
                                            ? Image.asset(
                                                'assets/images/packageplanimage.png',
                                                height: 18,
                                                width: 20)
                                            : Image.asset(
                                                'assets/images/packageplanimage1.png',
                                                height: 18,
                                                width: 20),
                                      ),

                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     Image.asset(
                                //       'assets/images/packageplanimage.png',
                                //       height: 19,
                                //       width: 20,
                                //     ),
                                //     Padding(
                                //       padding: const EdgeInsets.only(
                                //           left: 5, right: 5),
                                //       child: Text(
                                //         '+',
                                //         style: TextStyle(
                                //             color: white,
                                //             fontSize: 20,
                                //             fontWeight: FontWeight.w700),
                                //       ),
                                //     ),
                                //     Image.asset(
                                //         'assets/images/packageplanimage1.png',
                                //         height: 18,
                                //         width: 20),
                                //   ],
                                // ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    widget.package.name!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 10),
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      widget.package.discription!,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            height: 50,
                            width: MediaQuery.sizeOf(context).width * 0.31,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                              right: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                            )),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Check out Date'.tr,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            height: 149,
                            width: MediaQuery.sizeOf(context).width * 0.31,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                              right: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                            )),
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                DateFormat("dd/MM/yyyy").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(widget.order.id))),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            height: 50,
                            width: MediaQuery.sizeOf(context).width * 0.281,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                            )),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Price'.tr,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            height: 149,
                            width: MediaQuery.sizeOf(context).width * 0.281,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: borderdividercolor),
                            )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GradientText(
                                  textAlign: TextAlign.center,
                                  widget.package.price!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.clip),
                                  colors: [borderTop, gradientblue],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'AED'.tr,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.trainerprofile,
                      arguments: widget.trainer.id);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientText(
                       'Duration'.tr + ': ' + '${widget.package.duration}'.tr,
                       style: TextStyle(
                         fontSize: 14,
                         fontWeight: FontWeight.w600,
                       ),
                       colors: [borderTop, gradientblue],
                          ),
                      GradientText(
                        'View Profile'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        colors: [borderTop, gradientblue],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
