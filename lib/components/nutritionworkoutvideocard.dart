// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class Nutritionworkoutvideocard extends StatelessWidget {
  const Nutritionworkoutvideocard({
    Key? key,
    this.mytitle,
    this.thumbnailimage,
  }) : super(key: key);

  final mytitle;
  final thumbnailimage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: 125,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: bgContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Stack(children: [
            Container(
              height: 101,
              width: 106,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment(1.00, -0.03),
                    end: Alignment(-1, 0.03),
                    colors: [Color(0xFF58E0FF), Color(0xFF727DCD)],
                  )),
              child: thumbnailimage,
            ),
            Positioned(
                left: 37,
                top: 32,
                child: Image.asset(
                  'assets/images/playbutton.png',
                  height: 32,
                  width: 32,
                ))
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 23, bottom: 20),
                  child: Text(
                    mytitle,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Poppins'),
                  ),
                ),
                Text(
                  'Video',
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
