// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class GradientText1 extends StatelessWidget {
  GradientText1({
    super.key,
    this.text,
  });
  dynamic text;

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
      colors: [borderTop, gradientblue],
    );
  }
}
