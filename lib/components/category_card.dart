// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {super.key,
      @required this.title,
      @required this.image,
      @required this.firstColor,
      @required this.beginX,
      @required this.beginY,
      @required this.endX,
      @required this.endY,
      @required this.secondColor});
  final title;
  final image;
  final firstColor;
  final secondColor;
  final beginX;
  final beginY;
  final endX;
  final endY;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      // padding: EdgeInsets.only(top:30,bottom: 30,left: 10,right: 10),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(double.parse(beginX), double.parse(beginY)),
          end: Alignment(double.parse(endX), double.parse(endY)),
          colors: [
            firstColor,
            secondColor,
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fill,
          
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
