// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/api/post_api.dart';
import 'package:mudarribe_trainee/api/trainer_profile_api.dart';
import 'package:mudarribe_trainee/components/chat_me_card.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/eventDetailsCard.dart';
import 'package:mudarribe_trainee/components/packagecheckbox.dart';
import 'package:mudarribe_trainee/components/trainer_package_card.dart';
import 'package:mudarribe_trainee/components/trainer_profile_card.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/post.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_package.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mudarribe_trainee/views/chat/chat_page.dart';
import 'package:mudarribe_trainee/views/trainer/profile/profile_controller.dart';

class TrainerprofileView extends StatefulWidget {
  const TrainerprofileView({super.key});

  @override
  State<TrainerprofileView> createState() => _TrainerprofileViewState();
}

enum PackageType { monthBoth, month1, month2 }

class _TrainerprofileViewState extends State<TrainerprofileView> {
  String trainerId = '';

  @override
  Widget build(BuildContext context) {
    trainerId = Get.arguments;
    return GetBuilder<TrainerprofileController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: white,
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
                  color: Colors.black,
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(''),
                          Row(
                            children: [
                              Text(
                                controller.selectedPrice ?? '',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: whitewithopacity1),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, left: 6),
                                child: Text(
                                  'AED',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: whitewithopacity1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gap(5),
                      GradientButton(
                        title: 'Subscribe',
                        onPressed: () {
                          Get.offNamed(AppRoutes.packagecheckout,
                              arguments: controller.selectedPlan);
                        },
                        selected: true,
                        buttonHeight: MediaQuery.of(context).size.height * 0.07,
                      )
                    ],
                  ),
                ))
            : Text(''),
        body: SafeArea(
            child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 10.0, top: 10),
          child: Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15.0),
            width: MediaQuery.of(context).size.width * 0.99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              color: bgContainer,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<Trainer?>(
                      future: TrainerProfileApi.fetchTrainerData(trainerId),
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
                              categories: trainer.category.join(' & '),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 10, top: 35),
                              child: Divider(
                                thickness: 1,
                                color: dividercolor,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FutureBuilder<QuerySnapshot>(
                                    future: TrainerProfileApi.checkFollowing(
                                        trainerId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('');
                                      }
                                      if (!snapshot.hasData) {
                                        return Text('');
                                      }
                                      final docs = snapshot.data!.docs;
                                      RxBool isFollowing = docs.isNotEmpty
                                          ? true.obs
                                          : false.obs;

                                      return Obx(
                                        () => GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isFollowing =
                                                    isFollowing == true.obs
                                                        ? false.obs
                                                        : true.obs;
                                              });
                                              if (isFollowing.value) {
                                                TrainerProfileApi.followTrainer(
                                                    trainerId);
                                              }
                                              if (!isFollowing.value) {
                                                TrainerProfileApi
                                                    .unfollowTrainer(trainerId);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(top: 10),
                                              width: 264,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(5),
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment(1.00, -0.03),
                                                    end: Alignment(-1, 0.03),
                                                    colors: isFollowing.value
                                                        ? [
                                                            Colors.black,
                                                            Colors.black
                                                          ]
                                                        : [
                                                            Color(0xFF58E0FF),
                                                            Color(0xFF727DCD)
                                                          ],
                                                  )),
                                              child: Text(
                                                isFollowing.value
                                                    ? 'Following'
                                                    : 'Follow',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            )),
                                      );
                                    }),
                                InkWell(
                                  onTap: () {
                                    Get.off(() => ChatPage(
                                        arguments: ChatPageArguments(
                                            peerId: trainer.id,
                                            peerAvatar: trainer.profileImageUrl,
                                            peerNickname: trainer.name)));
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/chat.svg',
                                    width: 32,
                                    height: 33,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Posts',
                                style: TextStyle(
                                  color: controller.indexs == 0
                                      ? white
                                      : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/events.png',
                                width: 18,
                                height: 18,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Events',
                                  style: TextStyle(
                                    color: controller.indexs == 1
                                        ? white
                                        : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/packages.png',
                              width: 18,
                              height: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Packages',
                                style: TextStyle(
                                  color: controller.indexs == 2
                                      ? white
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
                      color: Colors.grey,
                      selectedColor: Colors.white,
                      selectedBorderColor: Colors.transparent,
                      fillColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller.indexs == 0
                      ? FutureBuilder<List<Post>>(
                          future: TrainerProfileApi.getTrainerPosts(trainerId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('');
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                heightFactor: 15,
                                child: Text(
                                  'No Posts Found !',
                                  style:
                                      TextStyle(color: white.withOpacity(0.7)),
                                ),
                              );
                            }
                            List<Post> posts = snapshot.data!;
                            
                            return posts.isNotEmpty ? GridView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: posts[index].imageUrl,
                                  fit: BoxFit.cover,
                                );
                              },
                            ):Center(
                                          heightFactor: 12,
                                          child: Text(
                                            'No Post Found !',
                                            style: TextStyle(
                                                color: white.withOpacity(0.7)),
                                          ),
                                        );
                          })
                      : controller.indexs == 1
                          ? Container(
                              constraints:
                                  BoxConstraints(minHeight: 10, maxHeight: 450),
                              child: FirestorePagination(
                                shrinkWrap: true,
                                isLive: false,
                                limit: 20,
                                onEmpty: Center(
                                  heightFactor: 15,
                                  child: Text(
                                    'No Events Found !',
                                    style: TextStyle(
                                        color: white.withOpacity(0.7)),
                                  ),
                                ),
                                viewType: ViewType.list,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                query: TrainerProfileApi.fetchTrainerEvents(
                                    trainerId),
                                bottomLoader: CircularProgressIndicator(),
                                itemBuilder:
                                    (context, documentSnapshot, index) {
                                  final eventData = documentSnapshot.data()
                                      as Map<String, dynamic>;

                                  final trainerId = eventData['trainerId'];
                                  Events events = Events.fromMap(eventData);
                                  return FutureBuilder<CombinedEventData>(
                                    future: HomeApi.fetchCombineEventData(
                                        trainerId, events),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('');
                                      }
                                      if (!snapshot.hasData) {
                                        return Center(
                                            heightFactor: 15,
                                            child: Text(
                                              'No Events Found !',
                                              style: TextStyle(
                                                  color:
                                                      white.withOpacity(0.7)),
                                            ));
                                      }

                                      CombinedEventData combineEvent =
                                          snapshot.data!;
                                      return FutureBuilder<QuerySnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('savedEvent')
                                              .where('userId',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('eventId',
                                                  isEqualTo: events.eventId)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text('');
                                            } else if (snapshot.hasError) {
                                              return Text('');
                                            } else {
                                              final docs = snapshot.data!.docs;
                                              bool saved = docs.isNotEmpty
                                                  ? true
                                                  : false;

                                              return EventDetailsCard(
                                                eventId:
                                                    combineEvent.event.eventId,
                                                category: combineEvent
                                                    .trainer.category
                                                    .join(' & '),
                                                name: combineEvent.trainer.name,
                                                image: combineEvent
                                                    .trainer.profileImageUrl,
                                                eventimg:
                                                    combineEvent.event.imageUrl,
                                                address:
                                                    combineEvent.event.address,
                                                startTime: combineEvent
                                                    .event.startTime,
                                                endTime:
                                                    combineEvent.event.endTime,
                                                date: combineEvent.event.date,
                                                capacity:
                                                    combineEvent.event.capacity,
                                                attendees: combineEvent
                                                    .eventOtherData
                                                    .totalAttendees,
                                                isJoined: combineEvent
                                                    .eventOtherData
                                                    .isCurrentUserAttendee,
                                                price: combineEvent.event.price,
                                                isSaved: saved,
                                                onSave: () {
                                                  setState(() {
                                                    saved = !saved;
                                                  });
                                                  if (saved) {
                                                    HomeApi.eventSaved(
                                                        events.eventId);
                                                  } else {
                                                    HomeApi.eventUnsaved(
                                                        events.eventId);
                                                  }
                                                },
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
                                    future:
                                        TrainerProfileApi.getTrainerPackages(
                                            trainerId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('');
                                      }
                                      if (!snapshot.hasData) {
                                        return Center(
                                          heightFactor: 15,
                                          child: Text(
                                            'No Package Found !',
                                            style: TextStyle(
                                                color: white.withOpacity(0.7)),
                                          ),
                                        );
                                      }
                                      List<TrainerPackage> packages =
                                          snapshot.data!;

                                      return snapshot.data!.isNotEmpty ?  ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: packages.length,
                                        itemBuilder: (context, index) {
                                          return TrainerPackageCard(
                                            name: packages[index].name,
                                            description:
                                                packages[index].discription,
                                            price: packages[index].price,
                                            category: packages[index].category,
                                            id: packages[index].id,
                                            selectedPlan:
                                                controller.selectedPlan,
                                            onTap: () async {
                                              await controller.toggleplan(
                                                  packages[index].id);
                                              await controller.toggleprice(
                                                  packages[index].price);
                                              setState(() {});
                                            },
                                          );
                                        },
                                      ):Center(
                                          heightFactor: 12,
                                          child: Text(
                                            'No Package Found !',
                                            style: TextStyle(
                                                color: white.withOpacity(0.7)),
                                          ),
                                        );
                                    }),
                                controller.indexs == 2 &&
                                        controller.selectedPlan != null &&
                                        controller.selectedPrice != null
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 40, bottom: 35),
                                            child: Row(children: <Widget>[
                                              Expanded(
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Divider(
                                                          color:
                                                              dividercolor))),
                                              Text(
                                                "Or ",
                                                style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: white),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 10),
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
                                        future:
                                            TrainerProfileApi.fetchTrainerData(
                                                trainerId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('');
                                          }
                                          if (!snapshot.hasData) {
                                            return Text('');
                                          }
                                          Trainer trainer = snapshot.data!;
                                          return ChatMeCard(
                                            userimg: trainer.profileImageUrl,
                                            username: trainer.name,
                                            chatText:
                                                'Chat With me for a personal plan',
                                            onChatClick: () {
                                              Get.off(() => ChatPage(
                                                  arguments: ChatPageArguments(
                                                      peerId: trainer.id,
                                                      peerAvatar: trainer
                                                          .profileImageUrl,
                                                      peerNickname:
                                                          trainer.name)));
                                            },
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
    );
  }
}
