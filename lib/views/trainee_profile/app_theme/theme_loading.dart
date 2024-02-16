import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';

class ThemeChangeLoading extends StatefulWidget {
  final bool background;

  const ThemeChangeLoading({
    Key? key,
    this.background = true,
  }) : super(key: key);

  @override
  State<ThemeChangeLoading> createState() => _ThemeChangeLoadingState();
}

class _ThemeChangeLoadingState extends State<ThemeChangeLoading> {
  wait() {
    Future.delayed(Duration(milliseconds: 100), () {
      Get.offNamed(AppRoutes.footer);
    });
  }

  @override
  void initState() {
    wait();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => progressIndicator;
}

Widget progressIndicator = Center(
  child: GifView.asset(
    'assets/images/infinity-loop.gif',
    height: 200,
    width: 200,
    frameRate: 60,
  ),
);
