// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/api/post_api.dart';
import 'package:mudarribe_trainee/api/trainer_profile_api.dart';
import 'package:mudarribe_trainee/api/trainer_saved.dart';
import 'package:mudarribe_trainee/components/chat_me_card.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/eventDetailsCard.dart';
import 'package:mudarribe_trainee/components/post_screen_card.dart';
import 'package:mudarribe_trainee/components/textgradient.dart';
import 'package:mudarribe_trainee/components/trainer_package_card.dart';
import 'package:mudarribe_trainee/components/trainer_profile_card.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/post_data_combined.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_package.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mudarribe_trainee/views/chat/chat_page.dart';
import 'package:mudarribe_trainee/views/chat/partials/send_messages.dart';
import 'package:mudarribe_trainee/views/chat/pdf_view.dart';
import 'package:mudarribe_trainee/views/trainer/profile/profile_controller.dart';

class TrainerprofileView extends StatefulWidget {
  const TrainerprofileView({super.key});

  @override
  State<TrainerprofileView> createState() => _TrainerprofileViewState();
}

enum PackageType { monthBoth, month1, month2 }

class _TrainerprofileViewState extends State<TrainerprofileView> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser == null) {
      Future.delayed(Duration.zero, () {
        setState(() {
          // Your state changes here
          Get.toNamed(AppRoutes.signin)!.then((value) {
            Get.offAllNamed(AppRoutes.footer);
            ;
          });
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Container()
        : GetBuilder<TrainerprofileController>(
            builder: (controller) => Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Get.isDarkMode ? black : white,
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Get.isDarkMode ? white : black,
                    ),
                  ),
                ),
                bottomNavigationBar: controller.indexs == 2 &&
                        controller.selectedPlan != null &&
                        controller.selectedPrice != null
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(''),
                                  Row(
                                    children: [
                                      Text(
                                        controller.selectedPrice ?? '',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 10, left: 6),
                                        child: Text(
                                          'AED'.tr,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Gap(5),
                              GradientButton(
                                title: 'Subscribe'.tr,
                                onPressed: () {
                                  Get.offNamed(AppRoutes.packagecheckout,
                                      arguments: controller.selectedPlan);
                                },
                                selected: true,
                                buttonHeight:
                                    MediaQuery.of(context).size.height * 0.07,
                              )
                            ],
                          ),
                        ))
                    : Text(''),
                body: SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10.0, top: 10),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 15.0),
                    width: MediaQuery.of(context).size.width * 0.99,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      color: Get.isDarkMode ? bgContainer : lightbgColor,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          FutureBuilder<Trainer?>(
                              future: TrainerProfileApi.fetchTrainerData(
                                  controller.trainerId),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('');
                                }
                                if (!snapshot.hasData) {
                                  return Text('');
                                }
                                Trainer trainer = snapshot.data!;
                                return Column(
                                  children: [
                                    TrainerProfileCard(
                                      userimg: trainer.profileImageUrl,
                                      username: trainer.name,
                                      bio: trainer.bio,
                                      categories: trainer.category,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          bottom: 10,
                                          top: 4),
                                      child: Divider(
                                        thickness: 1,
                                        color: dividercolor,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        FutureBuilder<QuerySnapshot>(
                                            future: TrainerProfileApi
                                                .checkFollowing(
                                                    controller.trainerId),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('');
                                              }
                                              if (!snapshot.hasData) {
                                                return Text('');
                                              }
                                              final docs = snapshot.data!.docs;
                                              RxBool isFollowing =
                                                  docs.isNotEmpty
                                                      ? true.obs
                                                      : false.obs;

                                              return Obx(
                                                () => GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isFollowing =
                                                            isFollowing ==
                                                                    true.obs
                                                                ? false.obs
                                                                : true.obs;
                                                      });
                                                      if (isFollowing.value) {
                                                        TrainerProfileApi
                                                            .followTrainer(
                                                                controller
                                                                    .trainerId);
                                                        setState(() {});
                                                        TrainerSaved
                                                            .trainerSaved(
                                                                controller
                                                                    .trainerId);
                                                      }
                                                      if (!isFollowing.value) {
                                                        TrainerProfileApi
                                                            .unfollowTrainer(
                                                                controller
                                                                    .trainerId);
                                                        TrainerSaved
                                                            .trainerUnsaved(
                                                                controller
                                                                    .trainerId);
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      width: Get.width * 0.65,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadiusDirectional
                                                                  .circular(5),
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment(
                                                                1.00, -0.03),
                                                            end: Alignment(
                                                                -1, 0.03),
                                                            colors: isFollowing
                                                                    .value
                                                                ? [
                                                                    bgContainer,
                                                                    bgContainer
                                                                  ]
                                                                : [
                                                                    Color(
                                                                        0xFF58E0FF),
                                                                    Color(
                                                                        0xFF727DCD)
                                                                  ],
                                                          )),
                                                      child: Text(
                                                        isFollowing.value
                                                            ? 'Following'.tr
                                                            : 'Follow'.tr,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Get.isDarkMode
                                                              ? Colors.white
                                                              : isFollowing
                                                                      .value
                                                                  ? black
                                                                  : white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    )),
                                              );
                                            }),
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => ChatPage(
                                                arguments: ChatPageArguments(
                                                    peerId: trainer.id,
                                                    peerAvatar:
                                                        trainer.profileImageUrl,
                                                    peerNickname:
                                                        trainer.name)));
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/chat.svg',
                                            width: 32,
                                            height: 33,
                                            color:
                                                Get.isDarkMode ? white : black,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            print(trainer.certificateUrl);
                                            createFileOfPdfUrl(
                                                    trainer.certificateUrl)
                                                .then((f) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFScreen(
                                                    path: f.path,
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/cover.svg',
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: ToggleButtons(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        'Posts'.tr,
                                        style: TextStyle(
                                          color: controller.indexs == 0
                                              ? Get.isDarkMode
                                                  ? white
                                                  : black
                                              : Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    // VerticalDivider(
                                    //   color: Colors.grey,
                                    //   thickness: 1,
                                    // ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, right: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: SvgPicture.asset(
                                          'assets/images/event-star.svg',
                                          width: 18,
                                          height: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          'Events'.tr,
                                          style: TextStyle(
                                            color: controller.indexs == 1
                                                ? Get.isDarkMode
                                                    ? white
                                                    : black
                                                : Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // VerticalDivider(
                                      //   color: Colors.grey,
                                      //   thickness: 1,
                                      // ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: SvgPicture.asset(
                                        'assets/images/three_box.svg',
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        'Packages'.tr,
                                        style: TextStyle(
                                          color: controller.indexs == 2
                                              ? Get.isDarkMode
                                                  ? white
                                                  : black
                                              : Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              isSelected: controller.selections,
                              onPressed: (int index) {
                                controller.handleToggleButtons(index);
                              },
                              color: Get.isDarkMode ? Colors.grey : black,
                              selectedColor: Get.isDarkMode ? white : grey,
                              selectedBorderColor:
                                  Get.isDarkMode ? bgContainer : grey,
                              fillColor: bgContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          controller.indexs == 0
                              ? FutureBuilder<List<CombinedData>>(
                                  future:
                                      TrainerProfileApi.fetchTrainerPostsData(
                                          controller.trainerId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        height: Get.height * 0.5,
                                        child: Center(
                                          child: CircularProgressIndicator(),
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
                                          'No Posts Found !'.tr,
                                          style: TextStyle(
                                              color: Get.isDarkMode
                                                  ? white.withOpacity(0.7)
                                                  : black.withOpacity(0.7)),
                                        ),
                                      );
                                    }
                                    List<CombinedData> posts = snapshot.data!;

                                    return posts.isNotEmpty
                                        ? GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                            ),
                                            itemCount: posts.length,
                                            itemBuilder: (context, index) {
                                              String time;
                                              int timestamp = int.parse(
                                                  posts[index].post.postId);
                                              DateTime dateTime = DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      timestamp);
                                              DateTime now = DateTime.now();
                                              Duration difference =
                                                  now.difference(dateTime);
                                              if (difference.inSeconds < 60) {
                                                time = 'just now';
                                              } else if (difference.inMinutes <
                                                  60) {
                                                time =
                                                    '${difference.inMinutes}m ago';
                                              } else if (difference.inHours <
                                                  24) {
                                                time =
                                                    '${difference.inHours}h ago';
                                              } else {
                                                time = DateFormat('dd MMM yyyy')
                                                    .format(dateTime);
                                              }
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(() => PostScreenCard(
                                                        userimg: posts[index]
                                                            .trainer
                                                            .profileImageUrl,
                                                        username: posts[index]
                                                            .trainer
                                                            .name,
                                                        postdescription:
                                                            posts[index]
                                                                .post
                                                                .caption,
                                                        postimg: posts[index]
                                                            .post
                                                            .imageUrl,
                                                        time: time,
                                                      ));
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             ));
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: posts[index]
                                                      .post
                                                      .imageUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            },
                                          )
                                        : Center(
                                            heightFactor: 12,
                                            child: Text(
                                              'No Posts Found !'.tr,
                                              style: TextStyle(
                                                  color: Get.isDarkMode
                                                      ? white.withOpacity(0.7)
                                                      : black.withOpacity(0.7)),
                                            ),
                                          );
                                  })
                              : controller.indexs == 1
                                  ? Container(
                                      // constraints:
                                      //     BoxConstraints(minHeight: 10, maxHeight: 450),
                                      child: FirestorePagination(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        isLive: false,
                                        limit: 20,
                                        onEmpty: Center(
                                          heightFactor: 15,
                                          child: Text(
                                            "No Events Found !".tr,
                                            style: TextStyle(
                                                color: Get.isDarkMode
                                                    ? white.withOpacity(0.7)
                                                    : black.withOpacity(0.7)),
                                          ),
                                        ),
                                        viewType: ViewType.list,
                                        // physics: BouncingScrollPhysics(),
                                        // scrollDirection: Axis,
                                        query: TrainerProfileApi
                                            .fetchTrainerEvents(
                                                controller.trainerId),
                                        bottomLoader:
                                            CircularProgressIndicator(),
                                        itemBuilder:
                                            (context, documentSnapshot, index) {
                                          final eventData = documentSnapshot
                                              .data() as Map<String, dynamic>;

                                          final trainerId =
                                              eventData['trainerId'];
                                          Events events =
                                              Events.fromMap(eventData);
                                          return FutureBuilder<
                                              CombinedEventData>(
                                            future:
                                                HomeApi.fetchCombineEventData(
                                                    trainerId, events),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Container(
                                                  height: Get.height * 0.5,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
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
                                                      "No Events Found !".tr,
                                                      style: TextStyle(
                                                          color: Get.isDarkMode
                                                              ? white
                                                                  .withOpacity(
                                                                      0.7)
                                                              : black
                                                                  .withOpacity(
                                                                      0.7)),
                                                    ));
                                              }

                                              CombinedEventData combineEvent =
                                                  snapshot.data!;
                                              return FutureBuilder<
                                                      QuerySnapshot>(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection('savedEvent')
                                                      .where('userId',
                                                          isEqualTo:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                      .where('eventId',
                                                          isEqualTo:
                                                              events.eventId)
                                                      .get(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container(
                                                        height:
                                                            Get.height * 0.5,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                    if (!snapshot.hasData) {
                                                      return Text('');
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text('');
                                                    } else {
                                                      final docs =
                                                          snapshot.data!.docs;
                                                      bool saved =
                                                          docs.isNotEmpty
                                                              ? true
                                                              : false;

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8),
                                                        child: EventDetailsCard(
                                                          eventId: combineEvent
                                                              .event.eventId,
                                                          category: combineEvent
                                                              .trainer.category,
                                                          trainerId:
                                                              combineEvent
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
                                                          startTime:
                                                              combineEvent.event
                                                                  .startTime,
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
                                                                  events
                                                                      .eventId);
                                                            } else {
                                                              HomeApi.eventUnsaved(
                                                                  events
                                                                      .eventId);
                                                            }
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  });
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        FutureBuilder<List<TrainerPackage>>(
                                            future: TrainerProfileApi
                                                .getTrainerPackages(
                                                    controller.trainerId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              if (snapshot.hasError) {
                                                return Text('');
                                              }
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  heightFactor: 15,
                                                  child: Text(
                                                    'No Packages Found !'.tr,
                                                    style: TextStyle(
                                                        color: Get.isDarkMode
                                                            ? white.withOpacity(
                                                                0.7)
                                                            : black.withOpacity(
                                                                0.7)),
                                                  ),
                                                );
                                              }
                                              List<TrainerPackage> packages =
                                                  snapshot.data!;

                                              return snapshot.data!.isNotEmpty
                                                  ? ListView.builder(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          packages.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 6,
                                                                  right: 6),
                                                          child:
                                                              TrainerPackageCard(
                                                            img2:
                                                                packages[index]
                                                                    .image2,
                                                            img: packages[index]
                                                                .image1,
                                                            duration:
                                                                packages[index]
                                                                    .duration,
                                                            name:
                                                                packages[index]
                                                                    .name,
                                                            description:
                                                                packages[index]
                                                                    .discription,
                                                            price:
                                                                packages[index]
                                                                    .price,
                                                            category:
                                                                packages[index]
                                                                    .category,
                                                            id: packages[index]
                                                                .id,
                                                            selectedPlan:
                                                                controller
                                                                    .selectedPlan,
                                                            onTap: () async {
                                                              await controller
                                                                  .toggleplan(
                                                                      packages[
                                                                              index]
                                                                          .id);
                                                              await controller
                                                                  .toggleprice(
                                                                      packages[
                                                                              index]
                                                                          .price);
                                                              setState(() {});
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Center(
                                                      heightFactor: 12,
                                                      child: Text(
                                                        'No Packages Found !'
                                                            .tr,
                                                        style: TextStyle(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? white
                                                                    .withOpacity(
                                                                        0.7)
                                                                : black
                                                                    .withOpacity(
                                                                        0.7)),
                                                      ),
                                                    );
                                            }),
                                        controller.indexs == 2
                                            ? Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20,
                                                            bottom: 25),
                                                    child:
                                                        Row(children: <Widget>[
                                                      Expanded(
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Divider(
                                                                  color:
                                                                      dividercolor))),
                                                      GradientText1(
                                                        text: "Or ",
                                                        // style: const TextStyle(
                                                        //     fontFamily:
                                                        //         "Poppins",
                                                        //     fontSize: 16,
                                                        //     fontWeight:
                                                        //         FontWeight.w500,
                                                        //     color: borderTop),
                                                      ),
                                                      Expanded(
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Divider(
                                                                  color:
                                                                      dividercolor))),
                                                    ]),
                                                  ),
                                                ],
                                              )
                                            : Text(''),
                                        controller.indexs == 2
                                            ? FutureBuilder<Trainer?>(
                                                future: TrainerProfileApi
                                                    .fetchTrainerData(
                                                        controller.trainerId),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text('');
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Text('');
                                                  }
                                                  Trainer trainer =
                                                      snapshot.data!;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 6, right: 6),
                                                    child: ChatMeCard(
                                                      userimg: trainer
                                                          .profileImageUrl,
                                                      username: trainer.name,
                                                      chatText:
                                                          'Chat With me for a personal plan'
                                                              .tr,
                                                      onChatClick: () {
                                                        Get.to(() => ChatPage(
                                                            arguments: ChatPageArguments(
                                                                peerId:
                                                                    trainer.id,
                                                                peerAvatar: trainer
                                                                    .profileImageUrl,
                                                                peerNickname:
                                                                    trainer
                                                                        .name)));
                                                      },
                                                    ),
                                                  );
                                                })
                                            : Text(''),
                                      ],
                                    ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ),
          );
  }
}
