// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mudarribe_trainee/components/appbar.dart';
import 'package:mudarribe_trainee/components/notificationView/excerciseplan.dart';
import 'package:mudarribe_trainee/components/notificationView/newmessage.dart';
import 'package:mudarribe_trainee/components/notificationView/nutritionplan.dart';
import 'package:mudarribe_trainee/components/notificationView/remainder.dart';
import 'package:mudarribe_trainee/components/notificationdivider.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopScreenBar(mytext: 'Notifications'),
            NewMessage(),
            DividerNotification(),
            ExcercisePlan(),
            DividerNotification(),
            NutritionPlan(),
            DividerNotification(),
            RemainderView(),
            DividerNotification(),
          ],
        ),
      ),
    );
  }
}
