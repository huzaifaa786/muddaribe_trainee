import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, @required this.title, @required this.image});
  final title;
  final image;
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(image),
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
                    fontSize:
                        title == 'Calisthenics' || title == 'Stick mobility'
                            ? 10
                            : title == 'Rehabilitation' ||
                                    title == 'Body Building' ||
                                    title == 'Indoor Cycling' ||
                                    title == 'Women fitness'
                                ? 9
                                : 11,
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
}
