// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_translator/google_translator.dart';
import 'package:mudarribe_trainee/api/notification_api.dart';
import 'package:mudarribe_trainee/components/appbar.dart';
import 'package:mudarribe_trainee/components/basic_loader.dart';
import 'package:mudarribe_trainee/components/notificationView/excerciseplan.dart';
import 'package:mudarribe_trainee/components/notificationView/newmessage.dart';
import 'package:mudarribe_trainee/components/notificationView/nutritionplan.dart';
import 'package:mudarribe_trainee/components/notificationView/remainder.dart';
import 'package:mudarribe_trainee/components/notificationdivider.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/combined_notification.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/events/myevents/myEvents_view.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: TopBar(text: 'Notifications'.tr),
      ),
      body: Directionality(
        textDirection:
            box.read('locale') == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: CustomMaterialIndicator(
          onRefresh: () async {
            setState(() {});
            Future.delayed(Duration(milliseconds: 1500));
          },
          indicatorBuilder: (context, controller) {
            return CupertinoActivityIndicator();
          },
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 12),
              child: FutureBuilder<List<CombinedTrainerNotification>>(
                  future: NotificationApi.fetchCombinedTrainerNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: Get.height * 0.7,
                        child: BasicLoader(
                          background: false,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('');
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        heightFactor: 15,
                        child: Text(
                          'No Notification Found!'.tr,
                          style: TextStyle(color: white.withOpacity(0.7)),
                        ),
                      );
                    }
                    List<CombinedTrainerNotification> notifications =
                        snapshot.data!;
                    return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return notifications[index].notification.type ==
                                  'plans'
                              ? Column(
                                  children: [
                                    ExcercisePlan(
                                      isRead: notifications[index]
                                          .notification
                                          .seen,
                                      content: notifications[index]
                                          .notification
                                          .content
                                          .tr,
                                      img: notifications[index]
                                          .trainer
                                          .profileImageUrl,
                                      name: notifications[index].trainer.name,
                                      ontap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('notifications')
                                            .doc(notifications[index]
                                                .notification
                                                .notificationId)
                                            .update({'seen': true}).then(
                                                (value) => print(
                                                    'sdkjdskfdsfsdfsdfsdfs'));
                                        Get.toNamed(AppRoutes.planFiles,
                                                parameters: {
                                              'planId': notifications[index]
                                                  .notification
                                                  .planId,
                                              'planName': notifications[index]
                                                  .notification
                                                  .planName,
                                              'trainerId': notifications[index]
                                                  .notification
                                                  .trainerId,
                                            })!
                                            .then((value) {
                                          Get.back();
                                          Get.to(
                                              () => const NotificationsView());
                                        });
                                      },
                                    ),
                                    DividerNotification(),
                                  ],
                                )
                              : Column(
                                  children: [
                                    RemainderView(
                                      isRead: notifications[index]
                                          .notification
                                          .seen,
                                      text: notifications[index]
                                                  .notification
                                                  .content ==
                                              'Event joined successfully.'
                                          ? 'View Events'.tr
                                          : 'View Trainer profile'.tr,
                                      content: notifications[index]
                                          .notification
                                          .content
                                          .tr,
                                      img: notifications[index]
                                          .trainer
                                          .profileImageUrl,
                                      name: notifications[index].trainer.name,
                                      ontap: () {
                                        FirebaseFirestore.instance
                                            .collection('notifications')
                                            .doc(notifications[index]
                                                .notification
                                                .notificationId)
                                            .update({'seen': true});
                                        if (notifications[index]
                                                .notification
                                                .content ==
                                            'Event joined successfully.') {
                                          Get.to(() => MyEventsView(),
                                                  arguments:
                                                      notifications[index]
                                                          .trainer
                                                          .id)!
                                              .then((value) {
                                            Get.back();
                                            Get.to(() =>
                                                const NotificationsView());
                                          });
                                        } else
                                          Get.toNamed(AppRoutes.trainerprofile,
                                                  arguments:
                                                      notifications[index]
                                                          .trainer
                                                          .id)!
                                              .then((value) {
                                            Get.back();
                                            Get.to(() =>
                                                const NotificationsView());
                                          });
                                      },
                                    ),
                                    DividerNotification(),
                                  ],
                                );
                        });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
