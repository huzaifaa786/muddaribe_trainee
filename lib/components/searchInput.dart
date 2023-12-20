// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key, this.ontap});
  final ontap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 48,
        decoration: ShapeDecoration(
          color: Color(0xFF18130F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(children: [
            SvgPicture.asset('assets/images/search.svg'),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              'Search about trainer, catigory',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4000000059604645),
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 0.27,
                letterSpacing: -0.13,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
