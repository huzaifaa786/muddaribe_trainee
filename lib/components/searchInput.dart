import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({Key? key, this.ontap}) : super(key: key);
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 48,
        decoration: ShapeDecoration(
          color: Get.isDarkMode ? black : lightbgColor, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            children: [
              SvgPicture.asset('assets/images/search.svg', color: Get.isDarkMode ? grey : black.withOpacity(0.5),),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                'Search'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  height: 0.27,
                  letterSpacing: -0.13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
