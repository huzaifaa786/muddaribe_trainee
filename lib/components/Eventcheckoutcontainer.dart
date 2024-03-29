// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class EventcheckoutContainer extends StatelessWidget {
  const EventcheckoutContainer({
    super.key,
    this.userimg,
    this.username,
    this.eventDate,
    this.categories,
    this.onProfileTap,
    this.price,
  });
  final userimg;
  final username;
  final eventDate;
  final price;
  final List<String>? categories;
  final onProfileTap;

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    return Container(
      // height: 130,
      padding: EdgeInsets.only(bottom: 20),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? black : lightbgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 19, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onProfileTap,
                  child: ClipOval(
                    child: Container(
                      width: 50,
                      height: 50,
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
                          image: CachedNetworkImageProvider(userimg),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 10.4),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: onProfileTap,
                            child: Text(
                              username,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: Get.width * 0.5,
                          //   child: Text(
                          //     categories,
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       fontFamily: 'Montserrat',
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //   ),
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: const EdgeInsets.only(top: 2, bottom: 8),
                            child: Wrap(
                              spacing: 10,
                              children: categories!.map((category) {
                                return Directionality(
                                  textDirection: box.read('locale') == 'ar'
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Get.isDarkMode ? white : black,
                                        size: 8,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        category,
                                        style: TextStyle(
                                          color: Get.isDarkMode ? white : black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/calender1.svg',
                                    color: Get.isDarkMode ? white : black),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 0),
                                  child: Text(
                                    eventDate,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                  child: Text(
                    price + ' ' + 'AED'.tr,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
