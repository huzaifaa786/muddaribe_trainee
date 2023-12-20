// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class Plancontainer extends StatelessWidget {
  const Plancontainer({
    Key? key,
    this.planimage,
    this.mytext,
    this.viewcontent,
  }) : super(key: key);

  final planimage;
  final mytext;
  final viewcontent;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
      child: Column(
        children: [
          Container(
            height: 260,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: bgContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: borderDown),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 20),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          mytext,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: white),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Stack(children: [
                      Container(
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: bgContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: planimage),
                      Positioned(
                          top: 80,
                          left: 100,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(viewcontent);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 8),
                              width: 135,
                              height: 33,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(5),
                                  gradient: LinearGradient(
                                    begin: Alignment(1.00, -0.03),
                                    end: Alignment(-1, 0.03),
                                    colors: [
                                      Color(0xFF58E0FF),
                                      Color(0xFF727DCD)
                                    ],
                                  )),
                              child: Text(
                                'View Content',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ))
                    ]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
