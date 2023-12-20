// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Fonts26 extends StatelessWidget {
  const Fonts26(
      {super.key,
      this.title,
      this.fontweight = FontWeight.w600,
      this.fontFamily = 'Poppins',
      this.align = TextAlign.center,
      this.color = Colors.white});
  final title;
  final fontweight;
  final fontFamily;
  final color;
  final align;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: 26,
        fontWeight: fontweight,
        color: color,
      ),
      textAlign: align,
    );
  }
}
