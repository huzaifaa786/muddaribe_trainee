// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/onboardings/fragments/fragment_1.dart';
import 'package:mudarribe_trainee/views/onboardings/fragments/fragment_2.dart';
import 'package:mudarribe_trainee/views/onboardings/fragments/fragment_3.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int slideIndex = 0;
  PageController? controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        slideIndex = index;
                      });
                    },
                    children: <Widget>[
                      FragmentOne(controller: controller!),
                      FragmentTwo(controller: controller!),
                      FragmentThree(controller: controller!),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        i == slideIndex
                            ? _buildPageIndicator(true)
                            : _buildPageIndicator(false),
                    ],
                  ),
                ),
                for (int i = 0; i < 2; i++)
                  slideIndex == i
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: GradientButton(
                            title: 'Next',
                            selected: true,
                            onPressed: () {
                              setState(() {
                                slideIndex++;
                                controller!.animateToPage(slideIndex,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.ease);
                              });
                            },
                          ),
                        )
                      : Container(),
                slideIndex == 2
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: GradientButton(
                          title: 'Get Started',
                          selected: true,
                          onPressed: () {
                            // UiUtilites.successSnackbar('fyuuiu','sdasdsafd');
                            Get.offNamed(AppRoutes.signup);
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildPageIndicator(bool isCurrentPage) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4.0),
    height: 10,
    width: 10,
    decoration: BoxDecoration(
      color: isCurrentPage ? Colors.grey : Colors.grey[300],
      border: isCurrentPage
          ? GradientBoxBorder(
              gradient: LinearGradient(
                  colors: [borderTop, borderDown],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              width: 5,
            )
          : GradientBoxBorder(
              gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
              width: 0,
            ),
      borderRadius: BorderRadius.circular(30),
    ),
  );
}
