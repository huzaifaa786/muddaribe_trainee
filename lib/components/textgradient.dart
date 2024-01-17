// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/translation.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class GradientText1 extends StatefulWidget {
  GradientText1({
    super.key,
    this.text,
    this.size =16.0,
  });
  dynamic text;
dynamic size;
  @override
  State<GradientText1> createState() => _GradientText1State();
}

class _GradientText1State extends State<GradientText1> {
  String? translatedText;

  @override
  void initState() {
    super.initState();
    translateText1(widget.text);
  }

  translateText1(String text) async {
    translatedText = await translateText(text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GradientText(
      translatedText ?? '',
      style: TextStyle(
        fontSize: widget.size,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
      colors: [borderTop, gradientblue],
    );
  }
}
