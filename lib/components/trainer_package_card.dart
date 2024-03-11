import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/components/packagecheckbox.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/gallery_image_view.dart';
import 'package:mudarribe_trainee/views/chat/full_photo_page.dart';

class TrainerPackageCard extends StatelessWidget {
  const TrainerPackageCard({
    super.key,
    this.category,
    this.price,
    this.name,
    this.description,
    this.duration,
    this.onchanged,
    this.onTap,
    this.id,
    this.img,
    this.img2,
    this.selectedPlan,
  });
  final category;
  final onTap;
  final price;
  final name;
  final description;
  final id;
  final duration;
  final onchanged;
  final selectedPlan;
  final img;
  final img2;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(alignment: Alignment.bottomLeft, children: [
        Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
            padding: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? bgContainer : grey.withOpacity(0.1),
              border: selectedPlan == id
                  ? GradientBoxBorder(
                      gradient: LinearGradient(colors: [borderTop, borderDown]),
                      width: 2,
                    )
                  : null,
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 70, top: 10, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      category == 'excercise&nutrition'
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/dumbel.svg',
                                    height: 19,
                                    width: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SvgPicture.asset('assets/images/nutri.svg',
                                      height: 18, width: 20),
                                ],
                              ),
                            )
                          : Text(''),
                      Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 6),
                            child: Text(
                              'AED'.tr,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      children: [
                        category == 'excercise'
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SvgPicture.asset(
                                  'assets/images/dumbel.svg',
                                  height: 19,
                                  width: 20,
                                ))
                            : category == 'nutrition'
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SvgPicture.asset(
                                      'assets/images/nutri.svg',
                                      height: 19,
                                      width: 20,
                                    ))
                                : Text(''),
                        Flexible(
                          child: SizedBox(
                            width: Get.width * 0.65,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.3,
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Row(
                                  children: [
                                    img != ''
                                        ? InkWell(
                                            onTap: () {
                                              Get.to(() => GalleryView(
                                                    imageUrls: [img, img2],
                                                    initialIndex: 0,
                                                  ));
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                img,
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    Gap(4),
                                    img2 != ''
                                        ? InkWell(
                                            onTap: () {
                                              Get.to(() => GalleryView(
                                                  imageUrls: [img, img2],
                                                  initialIndex: 1));
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                img2,
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(description,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          Text(
                            '$duration'.tr,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      img != '' && img2 != ''
                          ? GestureDetector(
                              onTap: () {
                                Get.to(() => GalleryView(
                                      imageUrls: [img, img2],
                                      initialIndex: 0,
                                    ));
                              },
                              child: Text(
                                'view',
                                style: TextStyle(
                                  color: Color(0xFF727DCD),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            )),
        Positioned(
            top: 3,
            right: 120,
            child: PackageCheckedBox(
                groupvalue: selectedPlan, value: id, onchanged: onchanged))
      ]),
    );
  }
}
