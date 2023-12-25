// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/notification_api.dart';
import 'package:mudarribe_trainee/components/appbar.dart';
import 'package:mudarribe_trainee/components/notificationView/excerciseplan.dart';
import 'package:mudarribe_trainee/components/notificationView/newmessage.dart';
import 'package:mudarribe_trainee/components/notificationView/nutritionplan.dart';
import 'package:mudarribe_trainee/components/notificationView/remainder.dart';
import 'package:mudarribe_trainee/components/notificationdivider.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/combined_notification.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
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
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: TopBar(text: 'Notifications'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<CombinedTrainerNotification>>(
            future: NotificationApi.fetchCombinedTrainerNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('');
              }
              if (!snapshot.hasData) {
                return Center(
                  heightFactor: 15,
                  child: Text(
                    'No Notification Found!',
                    style: TextStyle(color: white.withOpacity(0.7)),
                  ),
                );
              }
              List<CombinedTrainerNotification> notifications = snapshot.data!;
              return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ExcercisePlan(
                          content: notifications[index].notification.content,
                          img: notifications[index].trainer.profileImageUrl,
                          name: notifications[index].trainer.name,
                          ontap: () {
                            Get.toNamed(AppRoutes.planFiles, parameters: {
                              'planId':
                                  notifications[index].notification.planId,
                              'planName':
                                  notifications[index].notification.planName,
                              'trainerId':
                                  notifications[index].notification.trainerId,
                            });
                          },
                        ),
                        DividerNotification(),
                      ],
                    );
                    // return OrderCard(
                    //   trainer: notifications[index].combinedPackageData!.trainer,
                    //   package: notifications[index].combinedPackageData!.package,
                    //   order: notifications[index].order,
                    // );
                  });
            }),
        // child: Column(
        //   children: [

        // NewMessage(),
        // DividerNotification(),
        // ExcercisePlan(),
        // DividerNotification(),
        // NutritionPlan(),
        // DividerNotification(),
        // RemainderView(),
        // DividerNotification(),
        //   ],
        // ),
      ),
    );
  }
}
