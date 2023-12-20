// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mudarribe_trainee/components/appbar.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class EventDetailsCard extends StatelessWidget {
  const EventDetailsCard(
      {super.key,
      this.address,
      this.capcity,
      this.image,
      this.date,
      this.endTime,
      this.price,
      this.startTime,
      this.category,
      this.eventId,
      this.name,
      this.eventimg,
      this.isSaved,
      this.onSave});
  final address;
  final startTime;
  final endTime;
  final image;
  final date;
  final capcity;
  final price;
  final name;
  final category;
  final eventimg;
  final isSaved;
  final onSave;
  final eventId;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgContainer,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.9,
        padding: EdgeInsets.only(bottom: 20, top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                                  borderDown,
                                  borderDown
                                ],
                              ),
                              width: 1,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2.0, left: 10, right: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white
                                      .withOpacity(0.6000000238418579),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: onSave,
                    child: isSaved == false
                        ? Image.asset('assets/images/bookmark1.png')
                        : Image.asset('assets/images/bookmark-light.png'),
                  ),
                ],
              ),
            ),
            Container(
              height: 190,
              padding: EdgeInsets.only(left: 20, right: 20, top: 7.0),
              width: MediaQuery.sizeOf(context).width,
              child: Image.network(
                eventimg,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 7.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/location.svg',
                          fit: BoxFit.scaleDown, height: 24, width: 24),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: const EdgeInsets.only(left: 8, bottom: 3),
                        child: Text(
                          address,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/images/timeline.svg',
                          fit: BoxFit.scaleDown, height: 24, width: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 6),
                        child: Text(
                          'from $startTime to $endTime',
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
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/calender1.svg',
                          fit: BoxFit.scaleDown, height: 24, width: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 6),
                        child: Text(
                          date,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/images/peoplesharp.svg',
                          fit: BoxFit.scaleDown, height: 24, width: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 6),
                        child: Text(
                          'Total People amount: 0/$capcity',
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
                  Row(
                    children: [
                      Text(
                        'Price:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        ' $price AED',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.eventcheckout,
                                arguments: eventId);
                          },
                          child: GradientText1(
                            text: 'Join Event',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
