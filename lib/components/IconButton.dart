// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class IconButtons extends StatelessWidget {
  const IconButtons({
    Key? key,
    @required this.title,
    @required this.onPressed,
    this.text,
    this.textcolor = white,
    this.icon,
    this.sreenRatio = 1,
    this.gradientColors = const [borderTop, borderDown],
  }) : super(key: key);

  final title;
  final onPressed;
  final sreenRatio;
  final List<Color> gradientColors;
  final text;
  final textcolor;
  final icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * sreenRatio,
        height: 53,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  height: 45,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: textcolor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
