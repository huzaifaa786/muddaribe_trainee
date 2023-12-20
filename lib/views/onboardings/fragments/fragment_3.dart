// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class FragmentThree extends StatefulWidget {
  const FragmentThree({super.key, required this.controller});
  final PageController controller;
  @override
  State<FragmentThree> createState() => _FragmentThreeState();
}

class _FragmentThreeState extends State<FragmentThree> {
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
                      'assets/images/onboard3.png',
                    ),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.45,
                  ),
                  Positioned(
                      bottom: 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.9),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 40,
                                  spreadRadius: 30,
                                  color: Colors.black)
                            ]),
                        height: 40,
                        child: Text(
                          'sadsoirweruewuroiewuioooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooiwueroiwueoiruwe',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                      ))
                ],
              ),
              Container(
                  padding:
                      EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 40),
                  child: Text(
                    "Prepair Your tools and\nLets Started !",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: white,
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
