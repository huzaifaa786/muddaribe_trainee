// ignore_for_file: prefer_typing_uninitialized_variables, unused_field, unused_element, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/Myplans/myplans_view.dart';
import 'package:mudarribe_trainee/views/chat/chat_view.dart';
import 'package:mudarribe_trainee/views/events/myevents/myEvents_view.dart';
import 'package:mudarribe_trainee/views/footer/foot_text.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';
import 'dart:ui' as ui;
import 'package:badges/badges.dart' as badges;
import 'package:mudarribe_trainee/views/home/home_view.dart';
import 'package:mudarribe_trainee/views/trainee_profile/profile/profile_view.dart';

class FooterView extends StatefulWidget {
  const FooterView({Key? key}) : super(key: key);

  @override
  State<FooterView> createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView> with RouteAware {
  int _navigationMenuIndex = 0;
  @override
  Widget build(BuildContext context) {
    var _fragments = [
      const HomeView(),
      const ChatLsitScreen(),
      const MyplansView(),
      const MyEventsView(),
      const TraineeProfileView(),
    ];
    GetStorage box = GetStorage();
    return GetBuilder<HomeController>(
      autoRemove: false,
      initState: (state) {
        Future.delayed(Duration(milliseconds: 100), () {
          state.controller!
              .checkIfDocumentExists(FirebaseAuth.instance.currentUser!.uid);
          state.controller!.fetchDataFromFirestore();
          state.controller!.notiCountListener();
          state.controller!.countListener();
        });
      },
      builder: (controller) => Directionality(
        textDirection: box.read('locale') == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: WillPopScope(
          onWillPop: () => Future.value(false),
          child: Scaffold(
            body: SafeArea(
              child: _fragments[_navigationMenuIndex],
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 50,
              surfaceTintColor: Get.isDarkMode ? black : white,
              color: Get.isDarkMode ? black : white,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _navigationMenuIndex = 0;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        color: Get.isDarkMode ? black : white,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _navigationMenuIndex = 0;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _navigationMenuIndex == 0
                                    ? SvgPicture.asset(
                                        'assets/images/home.svg',
                                        fit: BoxFit.scaleDown,
                                        height: 16,
                                        width: 16,
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/homeunselected.svg',
                                        fit: BoxFit.scaleDown,
                                        height: 16,
                                        width: 16,
                                        color: Get.isDarkMode ? white : grey,
                                      ),
                                const Gap(4),
                                FooterText(
                                  text: 'Home'.tr,
                                  colors: _navigationMenuIndex == 0
                                      ? [borderDown, borderTop]
                                      : [grey, grey],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _navigationMenuIndex = 1;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        color: Get.isDarkMode ? black : white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              badges.Badge(
                                badgeStyle:
                                    badges.BadgeStyle(badgeColor: borderDown),
                                showBadge:
                                    controller.chatlength == 0 ? false : true,
                                badgeContent: Text(
                                  controller.chatlength.toString(),
                                  style: TextStyle(fontSize: 10,color: black),
                                ),
                                child: _navigationMenuIndex == 1
                                    ? SvgPicture.asset(
                                        'assets/images/msg.svg',
                                        fit: BoxFit.scaleDown,
                                        height: 16,
                                        width: 16,
                                        color: borderDown,
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/msg.svg',
                                        fit: BoxFit.scaleDown,
                                        height: 16,
                                        width: 16,
                                        color: Get.isDarkMode ? white : grey,
                                      ),
                              ),
                              const Gap(4),
                              FooterText(
                                  text: 'Chats'.tr,
                                  colors: _navigationMenuIndex == 1
                                      ? [borderDown, borderTop]
                                      : [grey, grey]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _navigationMenuIndex = 2;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        color: Get.isDarkMode ? black : white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _navigationMenuIndex == 2
                                  ? SvgPicture.asset(
                                      'assets/images/plansunselected.svg',
                                      fit: BoxFit.scaleDown,
                                      height: 16,
                                      width: 16,
                                      color: borderDown,
                                    )
                                  : SvgPicture.asset(
                                      'assets/images/plansunselected.svg',
                                      fit: BoxFit.scaleDown,
                                      height: 16,
                                      width: 16,
                                      color: Get.isDarkMode ? white : grey,
                                    ),
                              const Gap(4),
                              FooterText(
                                  text: 'My Plans'.tr,
                                  colors: _navigationMenuIndex == 2
                                      ? [borderDown, borderTop]
                                      : [grey, grey]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _navigationMenuIndex = 3;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        color: Get.isDarkMode ? black : white,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _navigationMenuIndex = 3;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _navigationMenuIndex == 3
                                    ? SvgPicture.asset(
                                        'assets/images/eventunselected.svg',
                                        fit: BoxFit.scaleDown,
                                        height: 16,
                                        width: 16,
                                        color: borderDown,
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/eventunselected.svg',
                                        fit: BoxFit.scaleDown,
                                        height: 16,
                                        width: 16,
                                        color: Get.isDarkMode ? white : grey,
                                      ),
                                const Gap(4),
                                FooterText(
                                  text: 'Events'.tr,
                                  colors: _navigationMenuIndex == 3
                                      ? [borderDown, borderTop]
                                      : [grey, grey],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _navigationMenuIndex = 4;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        color: Get.isDarkMode ? black : white,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _navigationMenuIndex = 4;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _navigationMenuIndex == 4
                                    ? SvgPicture.asset(
                                        'assets/images/profile.svg',
                                        fit: BoxFit.scaleDown,
                                        height: 16,
                                        width: 16,
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/profileunselected.svg',
                                        fit: BoxFit.scaleDown,
                                        height: 16,
                                        width: 16,
                                        color: Get.isDarkMode ? white : grey,
                                      ),
                                const Gap(4),
                                FooterText(
                                  text: 'Me'.tr,
                                  colors: _navigationMenuIndex == 4
                                      ? [borderDown, borderTop]
                                      : [grey, grey],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
