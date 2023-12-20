// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class TopScreenBar extends StatelessWidget {
  const TopScreenBar({
    super.key,
    this.mytext,
  });

  final mytext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 60),
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/arrowleft.svg',
          ),
          MaxGap(20),
          Text(
            mytext,
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
