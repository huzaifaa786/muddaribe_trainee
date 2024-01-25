// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/api/post_api.dart';
import 'package:mudarribe_trainee/api/save_api.dart';
import 'package:mudarribe_trainee/api/trainer_saved.dart';
import 'package:mudarribe_trainee/components/boxing_trainers_card.dart';
import 'package:mudarribe_trainee/components/eventDetailsCard.dart';
import 'package:mudarribe_trainee/components/post_card.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/post_data_combined.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/trainee_profile/saved/saved_controller.dart';
import 'dart:ui' as ui;

class SavedViews extends StatefulWidget {
  const SavedViews({Key? key}) : super(key: key);

  @override
  State<SavedViews> createState() => _SavedViewsState();
}

enum PackageType { Trainers, Events, Posts }

class _SavedViewsState extends State<SavedViews> {
  GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SavedController>(
      builder: (controller) => Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: white),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              'Saved'.tr,
              style: TextStyle(
                color: white,
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Directionality(
            textDirection: box.read('locale') == 'ar'
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
            child: SafeArea(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: borderTop,
                      indicatorWeight: 4,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          child: Text(
                            'Trainers'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Events'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Posts'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 26),
                        child: TabBarView(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: SaveApi.trainerStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(color: white),
                                  ));
                                } else if (!snapshot.hasData) {
                                  return SizedBox(
                                    height: Get.height,
                                    width: Get.width,
                                    child: Center(
                                        child: Text(
                                      'No Saved Trainer'.tr,
                                      style: TextStyle(color: white),
                                    )),
                                  );
                                } else {
                                  final saveTrainerSnapshot = snapshot.data;

                                  return snapshot.data!.docs.isNotEmpty
                                      ? FutureBuilder<List<Trainer>>(
                                          future: SaveApi.fetchTrainerData(
                                              saveTrainerSnapshot!),
                                          builder: (context, trainers) {
                                            if (trainers.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${trainers.error}'));
                                            } else if (!trainers.hasData) {
                                              return SizedBox(
                                                height: Get.height,
                                                width: Get.width,
                                                child: Center(
                                                    child: Text(
                                                  'No Saved Trainer'.tr,
                                                  style:
                                                      TextStyle(color: white),
                                                )),
                                              );
                                            } else {
                                              List<Trainer> trainerss =
                                                  trainers.data!;

                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: ListView.builder(
                                                    itemCount: trainerss.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Trainer trainer =
                                                          trainerss[index];
                                                      final docs =
                                                          saveTrainerSnapshot
                                                              .docs;
                                                      bool saved =
                                                          docs.isNotEmpty
                                                              ? true
                                                              : false;
                                                      return BoxingTrainersCard(
                                                          onProfileTap: () {
                                                            Get.toNamed(
                                                                AppRoutes
                                                                    .trainerprofile,
                                                                arguments:
                                                                    trainer.id);
                                                          },
                                                          title: trainer.name,
                                                          description: trainer
                                                              .category
                                                              .join('\n'),
                                                          rating:
                                                              trainer.rating,
                                                          imgpath1: trainer
                                                              .profileImageUrl,
                                                          isSaved: saved,
                                                          ontap: () {
                                                            setState(() {
                                                              saved = !saved;
                                                            });
                                                            if (saved ==
                                                                false) {
                                                              TrainerSaved
                                                                  .trainerUnsaved(
                                                                      trainer
                                                                          .id);
                                                            } else {
                                                              TrainerSaved
                                                                  .trainerSaved(
                                                                      trainer
                                                                          .id);
                                                            }
                                                          });
                                                    }),
                                              );
                                            }
                                          },
                                        )
                                      : SizedBox(
                                          height: Get.height,
                                          width: Get.width,
                                          child: Center(
                                              child: Text(
                                            'No Saved Trainer'.tr,
                                            style: TextStyle(color: white),
                                          )),
                                        );
                                }
                              },
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: SaveApi.eventStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(color: white),
                                  ));
                                } else if (!snapshot.hasData) {
                                  print('no event data');
                                  return SizedBox(
                                    height: Get.height * 0.1,
                                    width: Get.width * 0.5,
                                    child: Center(
                                        child: Text(
                                      'No Saved Event'.tr,
                                      style: TextStyle(color: white),
                                    )),
                                  );
                                } else {
                                  final saveEventSnapshot = snapshot.data;
                                  return snapshot.data!.docs.isNotEmpty
                                      ? FutureBuilder<List<CombinedEventData>>(
                                          future: SaveApi.fetchEventsData(
                                              saveEventSnapshot!),
                                          builder:
                                              (context, combinedEventData) {
                                            if (combinedEventData.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${combinedEventData.error}'));
                                            } else if (!combinedEventData
                                                .hasData) {
                                              return SizedBox(
                                                height: Get.height,
                                                width: Get.width,
                                                child: Center(
                                                    child: Text(
                                                  'No Saved Event'.tr,
                                                  style:
                                                      TextStyle(color: white),
                                                )),
                                              );
                                            } else {
                                              List<CombinedEventData> events =
                                                  combinedEventData.data!;
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: ListView.builder(
                                                    itemCount: events.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      CombinedEventData
                                                          combineEvent =
                                                          events[index];
                                                      final docs =
                                                          saveEventSnapshot
                                                              .docs;
                                                      bool saved =
                                                          docs.isNotEmpty
                                                              ? true
                                                              : false;
                                                      return EventDetailsCard(
                                                        eventId: combineEvent
                                                            .event.eventId,
                                                        category: combineEvent
                                                            .trainer.category
                                                            .join(' & '),
                                                        trainerId: combineEvent
                                                            .trainer.id,
                                                        name: combineEvent
                                                            .trainer.name,
                                                        image: combineEvent
                                                            .trainer
                                                            .profileImageUrl,
                                                        eventimg: combineEvent
                                                            .event.imageUrl,
                                                        address: combineEvent
                                                            .event.address,
                                                        startTime: combineEvent
                                                            .event.startTime,
                                                        endTime: combineEvent
                                                            .event.endTime,
                                                        date: combineEvent
                                                            .event.date,
                                                        capacity: combineEvent
                                                            .event.capacity,
                                                        attendees: combineEvent
                                                            .eventOtherData
                                                            .totalAttendees,
                                                        isJoined: combineEvent
                                                            .eventOtherData
                                                            .isCurrentUserAttendee,
                                                        price: combineEvent
                                                            .event.price,
                                                        isSaved: saved,
                                                        onSave: () {
                                                          setState(() {
                                                            saved = !saved;
                                                          });
                                                          if (saved) {
                                                            HomeApi.eventSaved(
                                                                combineEvent
                                                                    .event
                                                                    .eventId);
                                                          } else {
                                                            HomeApi.eventUnsaved(
                                                                combineEvent
                                                                    .event
                                                                    .eventId);
                                                          }
                                                        },
                                                      );
                                                    }),
                                              );
                                            }
                                          },
                                        )
                                      : SizedBox(
                                          height: Get.height,
                                          width: Get.width,
                                          child: Center(
                                              child: Text(
                                            'No Saved Event'.tr,
                                            style: TextStyle(color: white),
                                          )),
                                        );
                                }
                              },
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: SaveApi.postStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(color: white),
                                  ));
                                } else if (!snapshot.hasData) {
                                  return SizedBox(
                                    height: Get.height,
                                    width: Get.width,
                                    child: Center(
                                        child: Text(
                                      'No Saved Posts'.tr,
                                      style: TextStyle(color: white),
                                    )),
                                  );
                                } else {
                                  final savePostSnapshot = snapshot.data;
                                  return snapshot.data!.docs.isNotEmpty
                                      ? FutureBuilder<List<CombinedData>>(
                                          future: SaveApi.fetchPostsData(
                                              savePostSnapshot!),
                                          builder: (context, combinedPostData) {
                                            if (combinedPostData.hasError) {
                                              return Center(
                                                  child: Text(
                                                'Error: ${combinedPostData.error}',
                                                style: TextStyle(color: white),
                                              ));
                                            } else if (!combinedPostData
                                                .hasData) {
                                              return SizedBox(
                                                height: Get.height,
                                                width: Get.width,
                                                child: Center(
                                                    child: Text(
                                                  'No Saved Posts'.tr,
                                                  style:
                                                      TextStyle(color: white),
                                                )),
                                              );
                                            } else {
                                              List<CombinedData> posts =
                                                  combinedPostData.data!;
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: ListView.builder(
                                                    itemCount: posts.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      CombinedData postdata =
                                                          posts[index];
                                                      String time;
                                                      int timestamp = int.parse(
                                                          postdata.post.postId);
                                                      DateTime dateTime = DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              timestamp);
                                                      DateTime now =
                                                          DateTime.now();
                                                      Duration difference = now
                                                          .difference(dateTime);
                                                      if (difference.inSeconds <
                                                          60) {
                                                        time = 'just now';
                                                      } else if (difference
                                                              .inMinutes <
                                                          60) {
                                                        time =
                                                            '${difference.inMinutes}m ago';
                                                      } else if (difference
                                                              .inHours <
                                                          24) {
                                                        time =
                                                            '${difference.inHours}h ago';
                                                      } else {
                                                        time = DateFormat(
                                                                'dd MMM yyyy')
                                                            .format(dateTime);
                                                      }
                                                      final docs =
                                                          savePostSnapshot.docs;
                                                      bool saved =
                                                          docs.isNotEmpty
                                                              ? true
                                                              : false;
                                                      return PostCard(
                                                        userimg: postdata
                                                            .trainer
                                                            .profileImageUrl,
                                                        username: postdata
                                                            .trainer.name,
                                                        postimg: postdata
                                                            .post.imageUrl,
                                                        postdescription:
                                                            postdata
                                                                .post.caption,
                                                        time: time,
                                                        save: saved,
                                                        postId: postdata
                                                            .post.postId,
                                                        onsaved: () {
                                                          setState(() {
                                                            saved = !saved;
                                                          });
                                                          if (saved) {
                                                            HomeApi.postSaved(
                                                                postdata.post
                                                                    .postId);
                                                          } else {
                                                            HomeApi.postUnsaved(
                                                                postdata.post
                                                                    .postId);
                                                          }
                                                        },
                                                      );
                                                    }),
                                              );
                                            }
                                          },
                                        )
                                      : SizedBox(
                                          height: Get.height,
                                          width: Get.width,
                                          child: Center(
                                              child: Text(
                                            'No Saved Posts'.tr,
                                            style: TextStyle(color: white),
                                          )),
                                        );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
