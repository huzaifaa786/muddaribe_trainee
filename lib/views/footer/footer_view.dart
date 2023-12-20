// ignore_for_file: prefer_typing_uninitialized_variables, unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/Myplans/myplans_view.dart';
import 'package:mudarribe_trainee/views/events/allevents/allevents_view.dart';
import 'dart:ui' as ui;
import 'package:mudarribe_trainee/views/home/home_view.dart';
import 'package:mudarribe_trainee/views/trainee_profile/profile/profile_view.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class FooterView extends StatefulWidget {
  const FooterView({Key? key, this.selectedIndex}) : super(key: key);
  final selectedIndex;

  @override
  State<FooterView> createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView> with RouteAware {
  int _navigationMenuIndex = 0;
  @override
  Widget build(BuildContext context) {
   
    var _fragments = [
      const HomeView(),
      const MyplansView(),
      const AllEventsView(),
      const TraineeProfileView(),
    ];
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          body: SafeArea(
            child: _fragments[_navigationMenuIndex],
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 50,
            surfaceTintColor: Colors.black,
            color: Colors.black,
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
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.black,
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
                                    ),
                              const Gap(4),
                              GradientText(
                                'Home',
                                style: const TextStyle(
                                  fontSize: 10.0,
                                ),
                                colors: _navigationMenuIndex == 0
                                    ? [borderDown, borderTop]
                                    : [white, white],
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
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _navigationMenuIndex == 1
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
                                  ),
                            const Gap(4),
                            GradientText(
                              'My Plans',
                              style: const TextStyle(
                                fontSize: 10.0,
                              ),
                              colors: _navigationMenuIndex == 1
                                  ? [borderDown, borderTop]
                                  : [white, white],
                            ),
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
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.black,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _navigationMenuIndex = 2;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _navigationMenuIndex == 2
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
                                    ),
                              const Gap(4),
                              GradientText(
                                'Events',
                                style: const TextStyle(
                                  fontSize: 10.0,
                                ),
                                colors: _navigationMenuIndex == 2
                                    ? [borderDown, borderTop]
                                    : [white, white],
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
                        _navigationMenuIndex = 3;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.black,
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
                                    ),
                              const Gap(4),
                              GradientText(
                                'Me',
                                style: const TextStyle(
                                  fontSize: 10.0,
                                ),
                                colors: _navigationMenuIndex == 3
                                    ? [borderDown, borderTop]
                                    : [white, white],
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
    );
  }
}
