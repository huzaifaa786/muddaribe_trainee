// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    @required this.title,
    @required this.onPressed,
    this.selected = false,
    this.buttonwidth = 0.99,
    this.buttonHeight = 53.0
  }) : super(key: key);

  final title;
  final onPressed;
  final bool selected;
  final buttonwidth;
  final buttonHeight;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * buttonwidth,
        height: buttonHeight,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: selected
                  ? [borderTop, borderDown]
                  : [
                      const Color.fromARGB(255, 26, 25, 25),
                      const Color.fromARGB(255, 26, 25, 25)
                    ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
