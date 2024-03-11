// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
// import 'package:klicks_app/values/colors.dart';

class FragmentOne extends StatefulWidget {
  const FragmentOne({super.key, required this.controller});
  final PageController controller;

  @override
  State<FragmentOne> createState() => _FragmentOneState();
}

class _FragmentOneState extends State<FragmentOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/banner1.jpeg',
                    ),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                      bottom: 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.black.withOpacity(0.9)
                                : Colors.grey.withOpacity(0.4),
                            boxShadow: [
                              Get.isDarkMode
                                  ? BoxShadow(
                                      blurRadius: 40,
                                      spreadRadius: 30,
                                      color: Colors.black)
                                  : BoxShadow(
                                      blurRadius: 40,
                                      spreadRadius: 30,
                                      color: Colors.grey)
                            ]),
                        height: 10,
                        child: Text(
                          'sadsoirweruewuroiewuioooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooiwueroiwueoiruwe',
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.black.withOpacity(0.9)
                                : Colors.grey.withOpacity(0.4),
                          ),
                        ),
                      ))
                ],
              ),
              Container(
                  padding:
                      EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 10),
                  child: Text(
                    "Find the best trainer for you",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode ? white : black,
                      // height: 84 / 28,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Container(
                  padding:
                      EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 40),
                  child: Text(
                    "إبحث على أفضل مدرب لك",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode ? white : black,
                      // height: 84 / 28,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
