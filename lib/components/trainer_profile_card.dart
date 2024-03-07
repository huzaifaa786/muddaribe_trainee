import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class TrainerProfileCard extends StatelessWidget {
  const TrainerProfileCard({
    super.key,
    this.userimg,
    this.username,
    this.bio,
    this.categories,
  });
  final userimg;
  final username;
  final bio;
  final List<String>? categories;

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(4292214271),
            Color(4288538110),
            Color(4289505535),
            Color(4289494015),
            Color(4289494015),
            Color(4289491966),
            Color(4289491966),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
              height: 90,
              width: 90,
              margin: EdgeInsets.only(left: 10),
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
                borderRadius: BorderRadius.circular(45),
                child: CachedNetworkImage(
                  imageUrl: userimg,
                  fit: BoxFit.cover,
                ),
                // Image.network(userimg),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                      child: Text(
                        username,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600,color: white),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8, bottom: 8),
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width * 0.6,
                //     child: Text(
                //       categories,
                //       style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w400),
                //       maxLines: 2,
                //     ),
                //   ),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.only(top: 2, bottom: 8),
                  child: Wrap(
                    spacing: 10,
                    children: categories!.map((category) {
                      return Directionality(
                        textDirection: box.read('locale') == 'ar'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              color: white,
                              size: 10,
                            ),
                            SizedBox(width: 4),
                            Text(
                              category,
                              style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    bio,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,color: white
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
