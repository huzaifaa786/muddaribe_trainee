// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class Bodyworkplan extends StatelessWidget {
  const Bodyworkplan({
    super.key,
    this.mytext,
    this.onTap,
  });
  final mytext;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      height: 75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? black : lightbgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 55,
                width: 56,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    gradient: LinearGradient(
                      begin: Alignment(1.00, -0.03),
                      end: Alignment(-1, 0.03),
                      colors: [Color(0xFF58E0FF), Color(0xFF727DCD)],
                    )),
                child: Image.asset(
                  'assets/images/workplan.png',
                  width: 22,
                  height: 28,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width * 0.5,
                        child: Text(
                          mytext,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',),
                        ),
                      ),
                      Image.asset(
                        'assets/images/workplan1.png',
                        width: 24,
                        height: 22,
                        color: Get.isDarkMode ? white : black,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    '',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
