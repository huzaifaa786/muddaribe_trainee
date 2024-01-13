// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                'assets/images/nevigate.svg',
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Poppins",
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )).translate()
        ],
      ),
    );
  }
}
