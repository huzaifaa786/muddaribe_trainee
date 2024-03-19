// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:badges/badges.dart' as badges;

class MainTopBar extends StatelessWidget {
  const MainTopBar(
      {super.key, this.onNotiTap, this.onSearchTap, this.notiCount});
  final onNotiTap;
  final onSearchTap;
  final notiCount;
  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    return Padding(
      padding: box.read('locale') == 'ar'
          ? const EdgeInsets.only(top: 0, bottom: 0)
          : const EdgeInsets.only(top: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          box.read('locale') == 'ar'
              ? Image.asset('assets/images/homeLogoAr.png', width: 100)
              : Image.asset('assets/images/home_logo.png', height: 55),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // GestureDetector(
                //     onTap: () {
                //       Get.to(() => const ChatLsitScreen());
                //     },
                //     child: SvgPicture.asset('assets/images/msg.svg',
                //         fit: BoxFit.scaleDown,
                //         color: Get.isDarkMode ? Colors.white : Colors.black,
                //         )),
                FirebaseAuth.instance.currentUser == null
                    ? SizedBox()
                    : GestureDetector(
                        onTap: onNotiTap,
                        child: badges.Badge(
                          badgeContent: Text(
                            notiCount.toString(),
                            style: TextStyle(fontSize: 10, color: black),
                          ),
                          badgeStyle: badges.BadgeStyle(badgeColor: borderDown),
                          showBadge: notiCount == 0 ? false : true,
                          child: SvgPicture.asset(
                            'assets/images/notification.svg',
                            fit: BoxFit.scaleDown,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                GestureDetector(
                  onTap: onSearchTap,
                  child: SvgPicture.asset('assets/images/search.svg',
                      color: Get.isDarkMode ? white : Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
