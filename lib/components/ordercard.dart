// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15,top: 15),
      child: Container(
        height: 344,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: bgContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 19, top: 19),
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
                          image: AssetImage('assets/images/profile.jpg'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Salim Ahmed',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Body Building& lifting trainer',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.6000000238418579),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
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
                            bottom: BorderSide(width: 1, color: dividercolor),
                            right: BorderSide(width: 1, color: dividercolor),
                          )),
                          child: Text(
                            textAlign: TextAlign.center,
                            'Package',
                            style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          height: 149,
                          width: MediaQuery.sizeOf(context).width * 0.31,
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 1, color: dividercolor),
                            right: BorderSide(width: 1, color: dividercolor),
                          )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          color: white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Image.asset(
                                      'assets/images/packageplanimage1.png',
                                      height: 18,
                                      width: 20),
                                ],
                              ),
                              Text(
                                '1 month Plan',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: whitewithopacity1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                child: Text(
                                    textAlign: TextAlign.center,
                                    'Included Exercise & Nutrition Plan',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: whitewithopacity1)),
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
                            bottom: BorderSide(width: 1, color: dividercolor),
                            right: BorderSide(width: 1, color: dividercolor),
                          )),
                          child: Text(
                            textAlign: TextAlign.center,
                            'Check out Date',
                            style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          height: 149,
                          width: MediaQuery.sizeOf(context).width * 0.31,
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 1, color: dividercolor),
                            right: BorderSide(width: 1, color: dividercolor),
                          )),
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              '23 / 11 /2023',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: whitewithopacity1),
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
                            bottom: BorderSide(width: 1, color: dividercolor),
                          )),
                          child: Text(
                            textAlign: TextAlign.center,
                            'Price',
                            style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          height: 149,
                          width: MediaQuery.sizeOf(context).width * 0.281,
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 1, color: dividercolor),
                          )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GradientText(
                                textAlign: TextAlign.center,
                                '150.44',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                colors: [borderTop, gradientblue],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'AED',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: whitewithopacity1),
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
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GradientText(
                    'View Profile',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    colors: [borderTop, gradientblue],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
