// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class GradientText2 extends StatelessWidget {
  GradientText2({
    super.key,
    this.text,
    required TextStyle style,
    required List<Color> colors,
  });
  dynamic text;

  @override
  Widget build(BuildContext context) {
    return GradientText2(
      text: text,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
      colors: [borderTop, gradientblue],
    );
  }
}
