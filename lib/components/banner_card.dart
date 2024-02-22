// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/attenddee_api.dart';
import 'package:mudarribe_trainee/components/button.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:mudarribe_trainee/models/event_other_data.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class BannerCard extends StatelessWidget {
  const BannerCard(
      {super.key,
      this.image,
      this.endTime,
      this.enddate,
      this.date,
      this.price,
      this.startTime,
      this.joinTap,
      this.eventId,
      this.capacity,
      this.title});
  final image;
  final title;
  final date;
  final capacity;
  final startTime;
  final endTime;
  final enddate;
  final price;
  final eventId;
  final joinTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Get.isDarkMode?  bgContainer : Color(4294375158)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: image,
              height: 150,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(right: 8),
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Get.isDarkMode ? Colors.white: black,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
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
                                    image: AssetImage(
                                        "assets/images/calender.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0,right: 15),
                                child: Text(
                                  '$date - $enddate',
                                  style: TextStyle(
                                    color: Get.isDarkMode ? Colors.white: black,
                                    fontSize: 12,
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
                                '$price ' + 'AED'.tr,
                                style: TextStyle(
                                    color: Get.isDarkMode ? Colors.white: black,
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700),
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
                                    image:
                                        AssetImage("assets/images/clock.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0,right: 15),
                                child: Text(
                                  '$startTime - $endTime',
                                  style: TextStyle(
                                    color: Get.isDarkMode ? Colors.white: black,
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          FutureBuilder<EventOtherData>(
                              future: AttendeeApi.getAttendees(eventId),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text('');
                                } else if (snapshot.hasError) {
                                  return Text('');
                                } else {
                                  EventOtherData otherData = snapshot.data!;
                                  return int.parse(otherData.totalAttendees) <
                                              int.parse(capacity) &&
                                          otherData.isCurrentUserAttendee ==
                                              false
                                      ? Row(
                                          children: [
                                            CustomeButton(
                                              onPressed: joinTap,
                                              title: 'Join Event'.tr,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            GradientText1(
                                              text: 'Joined'.tr,
                                            ),
                                          ],
                                        );
                                }
                              }),
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
