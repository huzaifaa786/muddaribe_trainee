// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class DividerNotification extends StatefulWidget {
  const DividerNotification({super.key});

  @override
  State<DividerNotification> createState() => _DividerNotificationState();
}

class _DividerNotificationState extends State<DividerNotification> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Divider(
        thickness: 1,
        color: Get.isDarkMode ? dividercolor : black,
      ),
    );
  }
}
