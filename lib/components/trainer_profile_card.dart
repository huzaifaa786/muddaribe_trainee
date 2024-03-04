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
    return Row(
      children: [
        Container(
            height: 90,
            width: 90,
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
                    constraints: BoxConstraints(maxWidth: Get.width * 0.45),
                    child: Text(
                      username,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Image.asset(
                      'assets/images/verified_tick.png',
                      width: 20,
                      height: 20,
                    ),
                  )
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
                            color: Get.isDarkMode ? white : black,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            category,
                            style: TextStyle(
                              color: Get.isDarkMode ? white : black,
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
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
