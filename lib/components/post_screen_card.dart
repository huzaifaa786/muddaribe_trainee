// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:get/get.dart';

class PostScreenCard extends StatelessWidget {
  const PostScreenCard(
      {super.key,
      this.userimg,
      this.username,
      this.postdescription,
      this.postimg,
      this.time,
      this.postId,
      this.save,
      this.onProfileImageTap,
      this.onsaved});
  final userimg;
  final username;
  final onsaved;
  final postdescription;
  final postimg;
  final time;
  final postId;
  final save;
  final onProfileImageTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: TopBar(
          text: "",
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 12, left: 15, right: 15),
            padding: EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? bgContainer : lightbgColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: onProfileImageTap,
                            child: Container(
                                height: 50,
                                width: 50,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: GradientBoxBorder(
                                    gradient: LinearGradient(colors: const [
                                      gradientred,
                                      borderTop,
                                      borderDown,
                                      borderDown
                                    ]),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(imageUrl: userimg),
                                  // Image.network(userimg),
                                )),
                          ),
                          InkWell(
                            onTap: onProfileImageTap,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                username,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // InkWell(
                      //   onTap: onsaved,
                      //   child: save == false
                      //       ? SvgPicture.asset('assets/images/unsaved.svg')
                      //       : SvgPicture.asset('assets/images/post_saved2.svg'),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 16),
                  child: Container(
                    height: 353,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: postimg,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? bgContainer : lightbgColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                      padding: EdgeInsets.only(left: 10, right: 10, top: 18),
                      child: Text(
                        username + '  ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.9),
                      padding: EdgeInsets.only(left: 10, right: 10, top: 8),
                      child: Text(
                        postdescription,
                        style: TextStyle(
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.6)
                              : Colors.black.withOpacity(0.6),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Row(
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
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
