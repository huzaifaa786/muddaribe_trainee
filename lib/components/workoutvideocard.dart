// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class Workoutvideocard extends StatelessWidget {
  const Workoutvideocard({
    Key? key,
    this.videono,
    this.thumbnailimage,
  }) : super(key: key);

  final videono;
  final thumbnailimage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: 105,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: bgContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Stack(children: [
            Container(
              height: 77,
              width: 123,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment(1.00, -0.03),
                    end: Alignment(-1, 0.03),
                    colors: [Color(0xFF58E0FF), Color(0xFF727DCD)],
                  )),
              child: Image.asset('assets/images/body work plan.png'),
            ),
            Positioned(left: 50, top: 24, child: thumbnailimage)
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  videono,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontFamily: 'Poppins'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    'Full Body Energy',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: whitewithopacity1,
                        fontFamily: 'Poppins'),
                  ),
                ),
                Text(
                  '17 min/45kcal/L2 Beginner',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontFamily: 'Poppins'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
