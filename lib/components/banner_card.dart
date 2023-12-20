// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/components/button.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class BannerCard extends StatelessWidget {
  const BannerCard(
      {super.key,
      this.image,
      this.endTime,
      this.price,
      this.startTime,
      this.title});
  final image;
  final title;
  final startTime;
  final endTime;
  final price;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, top: 25, bottom: 25, right: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              title,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 6.0),
                    blurRadius: 1.0,
                    color: shadowBlack,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/calender.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      '$startTime',
                      style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '$price AED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 6.0),
                          blurRadius: 1.0,
                          color: shadowBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/clock.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      '$endTime',
                      style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomeButton(
                    onPressed: () {},
                    title: 'Join Event',
                  ),
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
