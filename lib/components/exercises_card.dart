import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class ExercisesCard extends StatelessWidget {
  const ExercisesCard(
      {super.key, required this.title, required this.description, this.onTap, this.trainerImage, this.trainerName});
  final String title;
  final String description;
  final trainerImage;
  final trainerName;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 8,right: 8,bottom: 12,top: 12),
          decoration: BoxDecoration(
              color: Get.isDarkMode ? black : grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: trainerImage,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * 0.6,
                    child: Text(trainerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  SizedBox(
                    width: Get.width * 0.6,
                    child: Text('Plan title'.tr+ ': ' + title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  Text(description,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
