// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class BoxingTrainersCard extends StatelessWidget {
  const BoxingTrainersCard({
    super.key,
    required this.title,
    required this.description,
    required this.imgpath1,
    this.isSaved = false,
    this.ontap,
    this.onProfileTap,
    this.rating,
  });

  final String title;
  final String description;
  final String imgpath1;
  final bool isSaved;
  final onProfileTap;
  final ontap;
  final rating;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onProfileTap,
      child: Container(
          constraints: BoxConstraints(minHeight: 112),
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Get.isDarkMode ? Color(0xFF0F0F0F) : lightbgColor,
              borderRadius: BorderRadius.circular(10)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                      imageUrl: imgpath1,
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          // Text('⭐ 4.5',
                          //     style: TextStyle(
                          //       color: Colors.amber,
                          //       fontSize: 10,
                          //       fontWeight: FontWeight.w500,
                          //     ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(description,
                        // max
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    rating == 0.0
                        ? SizedBox()
                        : Row(
                            children: [
                              Icon(Icons.star, color: borderDown, size: 20),
                              Text(' $rating',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          )
                  ],
                ),
              ],
            ),
            Container(
              constraints: BoxConstraints(minHeight: 112),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: ontap,
                    child: isSaved == false
                        ? Image.asset('assets/images/bookmark1.png')
                        : Image.asset('assets/images/bookmark-light.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Container(
                      width: 80,
                      height: 29,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Color(0xFF727DCD), Color(0xFF58E0FF)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: InkWell(
                        onTap: onProfileTap,
                        child: Center(
                          child: Text(
                            'View Profile'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])),
    );
  }
}
