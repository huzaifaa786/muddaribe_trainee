// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_translator/google_translator.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mudarribe_trainee/components/appbar.dart';
import 'package:mudarribe_trainee/components/location.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class EventDetailsCard extends StatelessWidget {
  const EventDetailsCard(
      {super.key,
      this.address,
      required this.trainerId,
      this.capacity,
      this.image,
      this.date,
      this.endTime,
      this.endDate,
      this.price,
      this.startTime,
      this.category,
      this.eventId,
      this.name,
      this.eventimg,
      this.isSaved,
      this.attendees,
      this.isJoined = false,
      this.onSave,
      this.onProfileTap});
  final address;
  final startTime;
  final endTime;
  final image;
  final trainerId;
  final date;
  final capacity;
  final price;
  final onProfileTap;
  final name;
  final List<String>? category;
  final eventimg;
  final isSaved;
  final onSave;
  final eventId;
  final attendees;
  final bool isJoined;
  final endDate;
  @override
  Widget build(BuildContext context) {
    Future<bool> getpermission() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Permission.location;
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        permission = await Geolocator.requestPermission();
        // return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return false;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      await Geolocator.getCurrentPosition();
      return true;
    }

    GetStorage box = GetStorage();
    return Container(
      // padding: EdgeInsets.only(left: 6,right: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Get.isDarkMode ? bgContainer : grey.withOpacity(0.1)),
      margin: EdgeInsets.only(left: 6, right: 6),
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
                    GestureDetector(
                      onTap: onProfileTap,
                      child: ClipOval(
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
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 2.0, left: 10, right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: onProfileTap,
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              padding: const EdgeInsets.only(top: 2, bottom: 8),
                              child: Wrap(
                                spacing: 10,
                                children: category!.map((category) {
                                  return Directionality(
                                    textDirection: box.read('locale') == 'ar'
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Get.isDarkMode
                                              ? Colors.white.withOpacity(
                                                  0.6000000238418579)
                                              : black.withOpacity(
                                                  0.6000000238418579),
                                          size: 10,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          category,
                                          style: TextStyle(
                                            color: Get.isDarkMode
                                                ? Colors.white.withOpacity(
                                                    0.6000000238418579)
                                                : black.withOpacity(
                                                    0.6000000238418579),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
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
                      ? SvgPicture.asset('assets/images/unsaved.svg')
                      : SvgPicture.asset('assets/images/post_saved2.svg'),
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
            padding: const EdgeInsets.only(left: 20, right: 20, top: 7.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/location.svg',
                        color: Get.isDarkMode ? white : black,
                        fit: BoxFit.scaleDown,
                        height: 24,
                        width: 24),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: const EdgeInsets.only(left: 8, bottom: 3),
                      child: Text(
                        address,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/images/timeline.svg',
                        color: Get.isDarkMode ? white : black,
                        fit: BoxFit.scaleDown,
                        height: 24,
                        width: 24),
                    Directionality(
                      textDirection: box.read('locale') == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 6),
                        child: Text(
                          'from'.tr + ' $startTime ' + 'to'.tr + ' $endTime',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/images/calender1.svg',
                        color: Get.isDarkMode ? white : black,
                        fit: BoxFit.scaleDown,
                        height: 24,
                        width: 24),
                    Directionality(
                      textDirection: box.read('locale') == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 6),
                        child: Text(
                          'from'.tr + ' $date ' + 'to'.tr + ' $endDate',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/images/peoplesharp.svg',
                        color: Get.isDarkMode ? white : black,
                        fit: BoxFit.scaleDown,
                        height: 24,
                        width: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 6),
                      child: Text(
                        'Total People amount'.tr +
                            ':' +
                            ' $attendees / $capacity',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Price'.tr + ':',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      ' $price ' + 'AED'.tr,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                // Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (await getpermission() == true) {
                          List<Location> locations =
                              await locationFromAddress(address);
                          if (locations.isNotEmpty) {
                            Location location = locations.first;
                            double latitude = location.latitude;
                            double longitude = location.longitude;
                            Get.to(() => MapView(
                                latitude: latitude, longitude: longitude));
                          }
                        }
                      },
                      child: GradientText1(
                        text: 'View Location'.tr,
                      ),
                    ),
                    int.parse(attendees) < int.parse(capacity) &&
                            isJoined == false
                        ? Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.eventcheckout,
                                        arguments: eventId,
                                        parameters: {'trainerId': trainerId});
                                  },
                                  child: GradientText1(
                                    text: 'Join Event'.tr,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GradientText1(
                                  text: 'Joined'.tr,
                                ),
                              ],
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
