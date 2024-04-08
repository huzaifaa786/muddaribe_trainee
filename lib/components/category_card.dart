import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show precacheImage;
import 'package:get/get.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, @required this.title, @required this.image})
      : super(key: key);

  final String? title;
  final String? image;

  // Preload the image during initialization
  static void preloadImage(BuildContext context, String image) {
    precacheImage(AssetImage(image), context);
  }

  @override
  Widget build(BuildContext context) {
    // Call the preloadImage() method during initialization
    preloadImage(context, image!);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(image!),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 2),
                color: Colors.black.withOpacity(0.10),
                child: Text(
                  "$title".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _getTitleFontSize(title!),
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getTitleFontSize(String title) {
    if (title == 'Calisthenics' || title == 'Stick mobility') {
      return 10;
    } else if (title == 'Rehabilitation' ||
        title == 'Body Building' ||
        title == 'Indoor Cycling' ||
        title == 'Women fitness') {
      return 9;
    } else {
      return 11;
    }
  }
}