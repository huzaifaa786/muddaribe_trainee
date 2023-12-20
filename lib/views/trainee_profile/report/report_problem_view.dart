// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors, prefer_const_literals_to_create_immutables, duplicate_ignore, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/inputfield.dart';
import 'package:mudarribe_trainee/components/password_inputField.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:mudarribe_trainee/components/textgradient2.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/authentication/change_password/change_password_contoller.dart';
import 'package:mudarribe_trainee/views/trainee_profile/report/report_problem_contoller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ReportProblemView extends StatefulWidget {
  const ReportProblemView({super.key});

  @override
  State<ReportProblemView> createState() => _ReportProblemViewState();
}

class _ReportProblemViewState extends State<ReportProblemView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportProblemController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 50),
                        child: Text(
                          'What’s the problem?',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: white),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 40, bottom: 25),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: bgContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InputField(
                            lable: 'Problem Text',
                            maxlines: 5,
                            controller: controller.report,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 43),
                            child: GestureDetector(
                              child: Container(
                                height: 52,
                                width: 215,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: gradientblue),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/image.png',
                                        height: 15,
                                        width: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: GradientText1(
                                          text: 'Upload Photo',
                                        ),
                                      )
                                    ]),
                              ),
                              onTap: () {
                                controller.reportuploadimage();
                              },
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GradientButton(
                    title: 'Report',
                    selected: controller.areFieldsFilled.value,
                    onPressed: () {
                      controller.areFieldsFilled.value == true;
                      controller.reportfun();
                      // : null;
                    },
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
