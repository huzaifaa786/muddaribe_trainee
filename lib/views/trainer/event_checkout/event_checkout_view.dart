// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/api/event_api.dart';
import 'package:mudarribe_trainee/components/Eventcheckoutcontainer.dart';
import 'package:mudarribe_trainee/components/basic_loader.dart';
import 'package:mudarribe_trainee/components/location.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/trainer/event_checkout/event_checkout_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class EventcheckoutView extends StatefulWidget {
  const EventcheckoutView({super.key});

  @override
  State<EventcheckoutView> createState() => _EventcheckoutViewState();
}

enum PaymentMethod { visa, googlePay, applePay }

class _EventcheckoutViewState extends State<EventcheckoutView> {
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
  @override
  Widget build(BuildContext context) {
    String eventId = Get.arguments;
    return GetBuilder<EventcheckoutController>(
      initState: (state) {
        Future.delayed(Duration(milliseconds: 100), () {
          state.controller!.eventId = eventId;
          setState(() {});
        });
      },
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: TopBar(
            text: "Event Check out".tr,
          ),
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(bottom: 30, top: 30, left: 20, right: 20),
          child: Obx(
            () => GestureDetector(
                onTap: () {
                  controller.payEventCharges(
                      controller.total == ''
                          ? controller.price
                          : controller.total,
                      Get.parameters['trainerId']);
                },
                child: Container(
                  padding: EdgeInsets.only(top: 17),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(5),
                      gradient: LinearGradient(
                        begin: Alignment(1.00, -0.03),
                        end: Alignment(-1, 0.03),
                        colors: controller.isButtonPressed.value
                            ? [bgContainer, bgContainer]
                            : [Color(0xFF58E0FF), Color(0xFF727DCD)],
                      )),
                  child: Text(
                    'Check Out'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )),
          ),
        ),
        body: SafeArea(
            child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              child: FutureBuilder<CombinedEventData?>(
                  future: EventApi.fetchEventData(controller.eventId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.data == null) {
                      return SizedBox(
                        height: Get.height * 0.8,
                        child: Center(
                          child: BasicLoader(
                            background: false,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('');
                    }
                    if (!snapshot.hasData) {
                      return Text('');
                    }
                    CombinedEventData combinedEventData = snapshot.data!;
                    controller.price = combinedEventData.event.price;
                    controller.firebaseToken =
                        combinedEventData.trainer.firebaseToken!;
                    controller.id = combinedEventData.trainer.id;

                    return Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: EventcheckoutContainer(
                            onProfileTap: () {
                              Get.toNamed(AppRoutes.trainerprofile,
                                  arguments: combinedEventData.trainer.id);
                            },
                            userimg: combinedEventData.trainer.profileImageUrl,
                            username: combinedEventData.trainer.name,
                            categories:
                                combinedEventData.trainer.category,
                            price: combinedEventData.event.price,
                            eventDate: combinedEventData.event.date,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 67,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Get.isDarkMode ? black : lightbgColor,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Promo Code'.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  controller.total != ''
                                      ? GradientText1(
                                          text: controller.promoCode.text,
                                        )
                                      : controller.isCode
                                          ? Row(
                                              children: [
                                                Container(
                                                    height: 35,
                                                    width: 110,
                                                    padding: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey),
                                                    child: TextField(
                                                      controller:
                                                          controller.promoCode,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              fillColor:
                                                                  Colors.grey,
                                                              focusColor:
                                                                  Colors.grey),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller.applyPromoCode(
                                                          combinedEventData
                                                              .trainer.id);
                                                    },
                                                    child: GradientText1(
                                                      text: 'Apply'.tr,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : InkWell(
                                              onTap: () {
                                                controller.isCode = true;
                                                setState(() {});
                                              },
                                              child: GradientText1(
                                                text: 'Add Code'.tr,
                                              ),
                                            )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Directionality(
                          textDirection: box.read('locale') == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: InkWell(
                            onTap: () async {
                              if (await getpermission() == true) {
                                List<Location> locations =
                                    await locationFromAddress(
                                        combinedEventData.event.address);
                                if (locations.isNotEmpty) {
                                  Location location = locations.first;
                                  double latitude = location.latitude;
                                  double longitude = location.longitude;
                                  Get.to(() => MapView(
                                      latitude: latitude,
                                      longitude: longitude));
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 12, right: 12),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/location.svg',
                                        color: Get.isDarkMode ? white : black),
                                  SizedBox(
                                    width: Get.width * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Container(
                                            width: Get.width * 0.6,
                                            child: Text(
                                              combinedEventData.event.address,
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GradientText1(
                                          text: 'View'.tr,
                                          size: 16.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Directionality(
                          textDirection: box.read('locale') == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 12, left: 12, right: 12),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/clock.svg',
                                    color: Get.isDarkMode ? white : black),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: SizedBox(
                                    // width: Get.width * 0.7,
                                    child: Directionality(
                                      textDirection: box.read('locale') == 'ar'
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      child: Text(
                                        '${combinedEventData.event.startTime} ' +
                                            'to'.tr +
                                            ' ${combinedEventData.event.endTime}',
                                        textAlign: box.read('locale') == 'ar'
                                            ? TextAlign.end
                                            : TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 35, left: 5, bottom: 20),
                          child: Row(
                            children: [
                              Text(
                                'Summary'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 216,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode ? black : lightbgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Price'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      combinedEventData.event.price +
                                          ' ' +
                                          'AED'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Divider(
                                  thickness: 1,
                                  color: dividercolor,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Offer'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      controller.discount.toString() +
                                          ' ' +
                                          'AED'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Divider(
                                  thickness: 1,
                                  color: dividercolor,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GradientText(
                                      'Total'.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      colors: [borderTop, gradientblue],
                                    ),
                                    Text(
                                      controller.total == ''
                                          ? controller.price + ' ' + 'AED'.tr
                                          : controller.total + ' ' + 'AED'.tr,
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..shader = LinearGradient(
                                              colors: <Color>[
                                                borderTop,
                                                borderTop,
                                              ],
                                            ).createShader(Rect.fromLTWH(
                                                0.0, 0.0, 250.0, 70.0))),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        )),
      ),
    );
  }
}
