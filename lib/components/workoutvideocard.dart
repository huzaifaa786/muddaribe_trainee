// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class Workoutvideocard extends StatelessWidget {
  const Workoutvideocard({
    Key? key,
    this.videoName,
    this.func,
    this.onTap,
  }) : super(key: key);

  final videoName;
  final func;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:5,bottom: 5,),
      padding: EdgeInsets.only(left: 10),
      height: 105,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? black : grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder<String?>(
                    future: func,
                    builder: (context, snapshot) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: snapshot.data != null
                            ? Image.file(
                                File(snapshot.data!),
                              )
                            : Image.asset(
                                'assets/images/containimg.png',
                                width:
                                    120, // Specify the width of the image to fit the Container
                                height:
                                    77, // Specify the height of the image to fit the Container
                                fit: BoxFit.fill,
                              ),
                      );
                    }),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    'assets/images/gridicon.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    videoName,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Get.isDarkMode ? white : black,
                        fontFamily: 'Poppins'),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                  //   child: Text(
                  //     'Full Body Energy',
                  //     style: TextStyle(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w600,
                  //         color: whitewithopacity1,
                  //         fontFamily: 'Poppins'),
                  //   ),
                  // ),
                  // Text(
                  //   '17 min/45kcal/L2 Beginner',
                  //   style: TextStyle(
                  //       fontSize: 10,
                  //       fontWeight: FontWeight.w600,
                  //       color: Color.fromRGBO(255, 255, 255, 0.6),
                  //       fontFamily: 'Poppins'),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
