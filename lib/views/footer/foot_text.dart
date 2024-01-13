// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/translation.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class FooterText extends StatefulWidget {
  FooterText({super.key, this.text, this.colors});
  dynamic text;
  final colors;

  @override
  State<FooterText> createState() => _FooterTextState();
}

class _FooterTextState extends State<FooterText> {
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
    return GradientText(translatedText ?? '...',
        style: const TextStyle(
          fontSize: 10.0,
        ),
        colors: widget.colors);
  }
}
