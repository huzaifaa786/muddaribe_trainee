import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({super.key,required this.text, required this.ontap});
  final ontap;
  final text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5))),
                  ),
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 50)),
                ),
                onPressed: ontap,
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Get.isDarkMode ? white : Color(0xff0f0a06),
                  ),
                ),
              );
  }
}