// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
class Bodyworkplan extends StatelessWidget {
  const Bodyworkplan({
    super.key,
     this.mytext,
   
  });
  final mytext;


  @override
  Widget build(BuildContext context) {
    return Container(
                height: 75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: bgContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
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
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mytext,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    color: whitewithopacity1),
                              ),
                              Image.asset(
                                'assets/images/workplan1.png',
                                width: 24,
                                height: 22,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            '305 kb',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color:
                                   Colors.white.withOpacity(0.6000000238418579)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
  }
}