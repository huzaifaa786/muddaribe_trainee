// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class EventcheckoutContainer extends StatelessWidget {
  const EventcheckoutContainer({
    super.key,
    this.userimg,
    this.username,
    this.eventDate,
    this.categories,
    this.price,
  });
  final userimg;
  final username;
  final eventDate;
  final price;
  final categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: bgContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 19, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Container(
                    width: 50,
                    height: 50,
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
                        image: CachedNetworkImageProvider(userimg),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 10.4),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            categories,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              color:
                                  Colors.white.withOpacity(0.6000000238418579),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/calender1.svg'),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 0),
                                  child: Text(
                                    eventDate,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    right: 14,
                  ),
                  child: Text(
                    price + ' AED',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
