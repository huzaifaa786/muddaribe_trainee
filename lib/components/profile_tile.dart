// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6, right: 10, left: 10),
      child: InkWell(
        onTap: widget.ontap,
        child: Container(
          height: 70,
          padding: EdgeInsets.only(right: 15, left: 15),
          decoration: BoxDecoration(
            color: Get.isDarkMode? bgContainer :white,
            boxShadow: [
              BoxShadow(color:Get.isDarkMode? Colors.black26: Colors.grey.withOpacity(0.3), blurRadius: 12),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    widget.img,
                    height: 20,
                    fit: BoxFit.scaleDown,
                  ),
                  Gap(12),
                  SizedBox(
                    width: Get.width * 0.65,
                    child: Text(
                      widget.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500),
                      // colors: [borderDown, borderTop],
                    ),
                  ),
                ],
              ),
              widget.logout == false
                  ? box.read('locale') == 'ar'
                      ? SvgPicture.asset(
                          'assets/images/arrow_backward.svg',
                          height: 20,
                          fit: BoxFit.scaleDown,
                        )
                      : SvgPicture.asset(
                          'assets/images/arrow_forward.svg',
                          height: 20,
                          fit: BoxFit.scaleDown,
                        )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
