// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ProfileTile extends StatefulWidget {
  const ProfileTile(
      {super.key, this.ontap, this.text, this.img, this.logout = false});
  final img;
  final text;
  final ontap;
  final logout;

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
@override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  widget.img,
                  height: 20,
                  fit: BoxFit.scaleDown,
                ),
                Gap(12),
                GradientText(
                  widget.text,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500),
                  colors: [borderDown, borderTop],
                ),
              ],
            ),
            widget.logout == false
                ? SvgPicture.asset(
                    'assets/images/arrow_forward.svg',
                    height: 20,
                    fit: BoxFit.scaleDown,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
