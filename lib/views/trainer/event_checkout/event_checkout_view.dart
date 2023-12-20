// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/api/event_api.dart';
import 'package:mudarribe_trainee/components/Eventcheckoutcontainer.dart';
import 'package:mudarribe_trainee/components/checkbox.dart';
import 'package:mudarribe_trainee/components/inputfield.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/trainer/event_checkout/event_checkout_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class EventcheckoutView extends StatefulWidget {
  const EventcheckoutView({super.key});

  @override
  State<EventcheckoutView> createState() => _EventcheckoutViewState();
}

enum PaymentMethod { visa, googlePay, applePay }

class _EventcheckoutViewState extends State<EventcheckoutView> {
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
            text: "Event Check out",
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
                  controller.payEventCharges();
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
                    'Check Out',
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
                    if (snapshot.hasError) {
                      return Text('');
                    }
                    if (!snapshot.hasData) {
                      return Text('');
                    }
                    CombinedEventData combinedEventData = snapshot.data!;
                    controller.price = combinedEventData.event.price;

                    return Column(
                      children: [
                        EventcheckoutContainer(
                          userimg: combinedEventData.trainer.profileImageUrl,
                          username: combinedEventData.trainer.name,
                          categories:
                              combinedEventData.trainer.category.join(' & '),
                          price: combinedEventData.event.price,
                          eventDate: combinedEventData.event.date,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 67,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: bgContainer,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Promo Code',
                                    style: TextStyle(
                                      color: white,
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
                                                        color: Colors.black),
                                                    child: TextField(
                                                      controller:
                                                          controller.promoCode,
                                                      style: TextStyle(
                                                          color: white),
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              fillColor:
                                                                  Colors.black,
                                                              focusColor:
                                                                  Colors.black),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller
                                                          .applyPromoCode();
                                                    },
                                                    child: GradientText1(
                                                      text: 'Apply',
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
                                                text: 'Add Code',
                                              ),
                                            )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 35, left: 5, bottom: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Summary',
                              style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 216,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: bgContainer,
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
                                      'Price ',
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      combinedEventData.event.price + ' AED',
                                      style: TextStyle(
                                        color: white,
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
                                      'Offer ',
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      controller.discount.toString() + ' AED',
                                      style: TextStyle(
                                        color: white,
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
                                      'Total',
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    GradientText(
                                      controller.total == ''
                                          ? controller.price
                                          : controller.total + ' AED',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      colors: [borderTop, gradientblue],
                                    ),
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
