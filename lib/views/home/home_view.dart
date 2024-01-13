// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/api/post_api.dart';
import 'package:mudarribe_trainee/components/banner_card.dart';
import 'package:mudarribe_trainee/components/category_card.dart';

import 'package:mudarribe_trainee/components/eventDetailsCard.dart';
import 'package:mudarribe_trainee/components/main_topbar.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:mudarribe_trainee/components/post_card.dart';
import 'package:mudarribe_trainee/components/searchInput.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/post_data_combined.dart';
import 'package:mudarribe_trainee/models/post.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/fontWeight.dart';
import 'package:mudarribe_trainee/views/categories/categories_result_view.dart';
import 'package:mudarribe_trainee/views/events/allevents/allevents_view.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      autoRemove: false,
      initState: (state) {
        Future.delayed(Duration(milliseconds: 100), () {
          state.controller!
              .checkIfDocumentExists(FirebaseAuth.instance.currentUser!.uid);
        });
      },
      builder: (controller) => Scaffold(
          body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: [
                MainTopBar(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SearchInput(
                          ontap: () {
                            Get.toNamed(AppRoutes.search)!.then((value) {
                              controller.checkIfDocumentExists(
                                  FirebaseAuth.instance.currentUser!.uid);
                            });
                          },
                        ),
                        // InkWell(
                        //     onTap: () {
                        //       controller.ontap();
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8),
                        //       child: Icon(
                        //         Icons.menu,
                        //         color: white,
                        //       ),
                        //     ))
                      ],
                    ),
                    controller.follewed != false
                        ?  Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Followed trainers',
                              style: TextStyle(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ).translate(),
                          )
                        : Container(),
                    controller.follewed != false
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            constraints:
                                BoxConstraints(minHeight: 0, maxHeight: 100),
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 80,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: const GradientBoxBorder(
                                      gradient: LinearGradient(colors: [
                                        Color(4290773187),
                                        Color(4285693389),
                                        Color(4278253801),
                                        Color(4278253801)
                                      ]),
                                      width: 1,
                                    ),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Center(
                                      child: GradientText(
                                        'Stories',
                                    colors: [borderTop, borderDown],
                                  )),
                                ),
                                FirestorePagination(
                                  shrinkWrap: true,
                                  isLive: true,
                                  limit: 6,
                                  onEmpty:
                                      Text('', style: TextStyle(color: white)),
                                  viewType: ViewType.list,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  query: HomeApi.trainerquery,
                                  bottomLoader: Center(
                                      child: CircularProgressIndicator()),
                                  itemBuilder:
                                      (context, documentSnapshot, index) {
                                    final trainerData = documentSnapshot.data()
                                        as Map<String, dynamic>;

                                    return FutureBuilder<Trainer?>(
                                        future: HomeApi.fetchTrainerStoryData(
                                            trainerData['trainerId']),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('');
                                          }
                                          if (!snapshot.hasData) {
                                            return Text('');
                                          }
                                          Trainer trainer = snapshot.data!;

                                          return InkWell(
                                            onTap: () {
                                              Get.toNamed(AppRoutes.stories,
                                                      arguments: trainer.id)!
                                                  .then((value) {
                                                controller
                                                    .checkIfDocumentExists(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid);
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border:
                                                        const GradientBoxBorder(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Color(4290773187),
                                                            Color(4285693389),
                                                            Color(4278253801),
                                                            Color(4278253801)
                                                          ]),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              trainer
                                                                  .profileImageUrl),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 12.0,
                                                    ),
                                                    child: Text(
                                                      trainer.name,
                                                      style: const TextStyle(
                                                          color: white,
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: weight500,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(),
                 controller.bannersList.isNotEmpty?   Container(
                      constraints: BoxConstraints(minHeight: 0, maxHeight: 300),
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 280,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                        ),
                        itemCount: controller.bannersList.length,
                        itemBuilder: (context, index, realIndex) {
                          Events banners = controller.bannersList[index];
                          return BannerCard(
                            joinTap: () {
                              Get.toNamed(AppRoutes.eventcheckout,
                                      arguments: banners.eventId)!
                                  .then((value) {
                                controller.checkIfDocumentExists(
                                    FirebaseAuth.instance.currentUser!.uid);
                              });
                            },
                            endTime: banners.endTime,
                            image: banners.imageUrl,
                            price: banners.price,
                            startTime: banners.startTime,
                            eventId: banners.eventId,
                            date: banners.date,
                            capacity: banners.capacity,
                            title: banners.title,
                          );
                        },
                      ),
                    ):Gap(0),
                    Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ).translate(),
                        InkWell(
                          onTap: () {
                            controller.showAllCategory();
                          },
                          child: Text(
                            'View all',
                            style: TextStyle(
                              color: Color(0xFF727DCD),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ).translate(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          controller.showAllCards ? controller.cards.length : 6,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.catigories,
                                    arguments: MyArguments(
                                        controller.cards[index]['title']!))!
                                .then((value) {
                              controller.checkIfDocumentExists(
                                  FirebaseAuth.instance.currentUser!.uid);
                            });
                          },
                          child: CategoryCard(
                            title: controller.cards[index]['title'],
                            image: controller.cards[index]['image'],
                            firstColor: Color(int.parse(
                                controller.cards[index]['firstColor']!)),
                            secondColor: Color(int.parse(
                                controller.cards[index]['secondColor']!)),
                            beginX: controller.cards[index]['beginX'],
                            beginY: controller.cards[index]['beginY'],
                            endX: controller.cards[index]['endX'],
                            endY: controller.cards[index]['endY'],
                          ),
                        );
                      },
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Events',
                          style: TextStyle(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ).translate(),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AllEventsView())!.then((value) {
                              controller.checkIfDocumentExists(
                                  FirebaseAuth.instance.currentUser!.uid);
                            });
                          },
                          child: Text(
                            'View all',
                            style: TextStyle(
                              color: Color(0xFF727DCD),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ).translate(),
                        ),
                      ],
                    ),
                    Gap(8),
                    Container(
                      constraints:
                          BoxConstraints(minHeight: 10, maxHeight: 450),
                      child: FirestorePagination(
                        shrinkWrap: true,
                        isLive: false,
                        limit: 20,
                        onEmpty: Text(
                          'No event uploaded yet.',
                          style: TextStyle(color: white.withOpacity(0.3)),
                        ).translate(),
                        viewType: ViewType.list,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        query: HomeApi.eventquery,
                        bottomLoader:
                            Center(child: CircularProgressIndicator()),
                        itemBuilder: (context, documentSnapshot, index) {
                          final eventData =
                              documentSnapshot.data() as Map<String, dynamic>;
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
                                return Text('');
                              }

                              CombinedEventData combineEvent = snapshot.data!;
                              print(combineEvent
                                  .eventOtherData.isCurrentUserAttendee);

                              return FutureBuilder<QuerySnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('savedEvent')
                                      .where('userId',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
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
                                      bool saved =
                                          docs.isNotEmpty ? true : false;

                                      return EventDetailsCard(
                                        category: combineEvent.trainer.category
                                            .join(' & '),
                                        name: combineEvent.trainer.name,
                                        image: combineEvent
                                            .trainer.profileImageUrl,
                                        eventimg: combineEvent.event.imageUrl,
                                        address: combineEvent.event.address,
                                        startTime: combineEvent.event.startTime,
                                        endTime: combineEvent.event.endTime,
                                        date: combineEvent.event.date,
                                        capacity: combineEvent.event.capacity,
                                        attendees: combineEvent
                                            .eventOtherData.totalAttendees,
                                        isJoined: combineEvent.eventOtherData
                                            .isCurrentUserAttendee,
                                        price: combineEvent.event.price,
                                        isSaved: saved,
                                        eventId: combineEvent.event.eventId,
                                        onSave: () {
                                          setState(() {
                                            saved = !saved;
                                          });
                                          if (saved) {
                                            HomeApi.eventSaved(events.eventId);
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
                    ),
                    Gap(20),
                    Text(
                      'Posts',
                      style: TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ).translate(),
                    Gap(15),
                    FirestorePagination(
                      shrinkWrap: true,
                      isLive: true,
                      limit: 20,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      query: HomeApi.postquery,
                      bottomLoader: Center(child: CircularProgressIndicator()),
                      itemBuilder: (context, documentSnapshot, index) {
                        final postDatas =
                            documentSnapshot.data() as Map<String, dynamic>;
                        final trainerId = postDatas['trainerId'];
                        return FutureBuilder<Trainer>(
                          future: HomeApi.fetchTrainerData(trainerId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('');
                            }
                            if (!snapshot.hasData) {
                              return Text('');
                            }
                            Trainer trainerData = snapshot.data!;
                            Post posts = Post.fromMap(postDatas);
                            CombinedData postdata =
                                CombinedData(trainer: trainerData, post: posts);
                            String time;
                            int timestamp = int.parse(posts.postId);
                            DateTime dateTime =
                                DateTime.fromMillisecondsSinceEpoch(timestamp);
                            DateTime now = DateTime.now();
                            Duration difference = now.difference(dateTime);
                            if (difference.inSeconds < 60) {
                              time = 'just now';
                            } else if (difference.inMinutes < 60) {
                              time = '${difference.inMinutes}m ago';
                            } else if (difference.inHours < 24) {
                              time = '${difference.inHours}h ago';
                            } else {
                              time = DateFormat('dd MMM yyyy').format(dateTime);
                            }
                            return FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('savedPost')
                                  .where('userId',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .where('postId',
                                      isEqualTo: postdata.post.postId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text('');
                                } else if (snapshot.hasError) {
                                  return Text('');
                                } else {
                                  final docs = snapshot.data!.docs;
                                  bool saved = docs.isNotEmpty ? true : false;
                                  return PostCard(
                                    onProfileImageTap: () {
                                      Get.toNamed(AppRoutes.trainerprofile,
                                              arguments: postdata.trainer.id)!
                                          .then((value) {
                                        controller.checkIfDocumentExists(
                                            FirebaseAuth
                                                .instance.currentUser!.uid);
                                      });
                                    },
                                    userimg: postdata.trainer.profileImageUrl,
                                    username: postdata.trainer.name,
                                    postimg: postdata.post.imageUrl,
                                    postdescription: postdata.post.caption,
                                    time: time,
                                    save: saved,
                                    postId: postdata.post.postId,
                                    onsaved: () {
                                      setState(() {
                                        saved = !saved;
                                      });
                                      if (saved) {
                                        HomeApi.postSaved(postdata.post.postId);
                                      } else {
                                        HomeApi.postUnsaved(
                                            postdata.post.postId);
                                      }
                                    },
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
