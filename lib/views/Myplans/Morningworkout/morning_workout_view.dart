// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/components/bodyworkplan.dart';
import 'package:mudarribe_trainee/components/workoutvideocard.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/Myplans/Morningworkout/morning_workout_controller.dart';

class MornningworkoutView extends StatefulWidget {
  const MornningworkoutView({super.key});

  @override
  State<MornningworkoutView> createState() => _MornningworkoutViewState();
}

class _MornningworkoutViewState extends State<MornningworkoutView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MornningworkoutController>(
        builder: (controller) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                leading: Icon(
                  Icons.arrow_back_ios_new,
                  color: white,
                ),
                title: Text(
                  'morning workouts',
                  style: TextStyle(
                      fontSize: 20,
                      color: whitewithopacity1,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins'),
                ),
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: bgContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: borderDown),
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/chat.svg',
                                    width: 26,
                                    height: 23,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: const GradientBoxBorder(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 184, 66, 186),
                                              Color.fromARGB(
                                                  255, 111, 127, 247),
                                            ],
                                          ),
                                          width: 2,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/profile.jpg'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0, left: 10, right: 10),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Ahmed_67',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              color: whitewithopacity1,
                                            ),
                                          ),
                                          Text(
                                            'Body building trainer',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white.withOpacity(
                                                  0.6000000238418579),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          height: 136,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: bgContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Discription',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                        color: whitewithopacity1),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'for today we have those workouts to build the muscles ,Brath deaply and start your trainning',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        color: Colors.white
                                            .withOpacity(0.6000000238418579),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Bodyworkplan(mytext:'Full Body work plan ',),
                      ),
                      Workoutvideocard(
                        videono: '01',
                        thumbnailimage: Image.asset(
                          'assets/images/playbutton.png',
                          height: 32,
                          width: 32,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Bodyworkplan(mytext: 'Full Body work plan ',),
                      ),
                      Workoutvideocard(
                        videono: '02',
                        thumbnailimage: Image.asset(
                          'assets/images/playbutton.png',
                          height: 32,
                          width: 32,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Workoutvideocard(
                          videono: '03',
                          thumbnailimage: Image.asset(
                            'assets/images/playbutton.png',
                            height: 32,
                            width: 32,
                          ),
                        ),
                      ),
                      Workoutvideocard(
                        videono: '04',
                        thumbnailimage: Image.asset(
                          'assets/images/playbutton.png',
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ));
  }
}
