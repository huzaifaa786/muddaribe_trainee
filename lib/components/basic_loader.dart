import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class BasicLoader extends StatelessWidget {
  final bool background;

  const BasicLoader({
    Key? key,
    this.background = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        color: Get.isDarkMode ? Colors.black : white,
        child: progressIndicator,
      );
  // : progressIndicator;
}

Widget progressIndicator = Center(
  child: GifView.asset(
    'assets/images/infinity-loop.gif',
    height: 200,
    width: 200,
    frameRate: 60,
  ),
);
