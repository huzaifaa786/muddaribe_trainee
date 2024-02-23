// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class FragmentTwo extends StatefulWidget {
  const FragmentTwo({super.key, required this.controller});
  final PageController controller;
  @override
  State<FragmentTwo> createState() => _FragmentTwoState();
}

class _FragmentTwoState extends State<FragmentTwo> {
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
                        'assets/images/onboard2.png',
                      ),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5),
                      Positioned(
                      bottom: 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF000000).withOpacity(0.9),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 40,
                                  spreadRadius: 30,
                                  color: Colors.black)
                            ]),
                        height: 10,
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
                      EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 10),
                  child: Text(
                    'We provide meal plans\nthat suits your goals!',
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                    textAlign: TextAlign.center,
                  )),
                   Container(
                  padding:
                      EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 40),
                  child: Text(
                    'نحن نقدم خطط الوجبات\nالتي تناسب أهدافك!',
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: white,
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
