// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:mudarribe_trainee/api/event_api.dart';
import 'package:mudarribe_trainee/api/post_api.dart';
import 'package:mudarribe_trainee/components/appbar.dart';
import 'package:mudarribe_trainee/components/basic_loader.dart';
import 'package:mudarribe_trainee/components/loading_indicator.dart';
import 'package:mudarribe_trainee/components/myEventContainer.dart';
import 'package:mudarribe_trainee/components/eventDetailsCard.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/events/myevents/myEvents_controller.dart';

class MyEventsView extends StatefulWidget {
  const MyEventsView({super.key});

  @override
  State<MyEventsView> createState() => _MyEventsViewState();
}

class _MyEventsViewState extends State<MyEventsView> {
  final myEvent = MyEventController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'My Events'.tr,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12),
          child: FutureBuilder<List<CombinedEventData>>(
            future: myEvent.getEventAttendeesWithInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No event joined yet.'.tr),
                );
              } else {
                return ListView.builder(
                  // shrinkWrap: true,
                  // physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var combineEvent = snapshot.data![index];
                    return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('savedEvent')
                            .where('userId',
                                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                            .where('eventId',
                                isEqualTo: combineEvent.event.eventId)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('');
                          } else if (snapshot.hasError) {
                            return Text('');
                          } else {
                            final docs = snapshot.data!.docs;
                            bool saved = docs.isNotEmpty ? true : false;
                            return EventDetailsCard(
                              category: combineEvent.trainer.category.join(' & '),
                              name: combineEvent.trainer.name,
                              trainerId: combineEvent.trainer.id,
                              image: combineEvent.trainer.profileImageUrl,
                              eventimg: combineEvent.event.imageUrl,
                              address: combineEvent.event.address,
                              startTime: combineEvent.event.startTime,
                              endTime: combineEvent.event.endTime,
                              date: combineEvent.event.date,
                              endDate: combineEvent.event.todate,
                              capacity: combineEvent.event.capacity,
                              attendees:
                                  combineEvent.eventOtherData.totalAttendees,
                              isJoined: combineEvent
                                  .eventOtherData.isCurrentUserAttendee,
                              price: combineEvent.event.price,
                              isSaved: saved,
                              eventId: combineEvent.event.eventId,
                              onProfileTap: () {
                                Get.toNamed(AppRoutes.trainerprofile,
                                    arguments: combineEvent.trainer.id);
                              },
                              onSave: () {
                                setState(() {
                                  saved = !saved;
                                });
                                if (saved) {
                                  HomeApi.eventSaved(combineEvent.event.eventId);
                                } else {
                                  HomeApi.eventUnsaved(
                                      combineEvent.event.eventId);
                                }
                              },
                            );
                          }
                        });
                  },
                );
              }
            },
          ),
        ),
      ),
      // child: Container(
      //   padding: EdgeInsets.only(left: 5, right: 5),
      //   child: FirestorePagination(
      //     bottomLoader: BasicLoader(background: false),
      //     initialLoader: BasicLoader(background: false),
      //     shrinkWrap: true,
      //     isLive: false,
      //     limit: 20,
      //     onEmpty: Center(
      //       child: Text(
      //         'No event joined yet.'.tr,
      //       ),
      //     ),
      //     viewType: ViewType.list,
      //     physics: BouncingScrollPhysics(),
      //     scrollDirection: Axis.vertical,
      //     query: EventApi.eventquery,
      //     itemBuilder: (context, documentSnapshot, index) {
      //       final eventData = documentSnapshot.data() as Map<String, dynamic>;
      //       final trainerId = eventData['trainerId'];
      //       Events events = Events.fromMap(eventData);
      //       return FutureBuilder<CombinedEventData>(
      //         future: HomeApi.fetchCombineEventData(trainerId, events),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasError) {
      //             return Text(
      //               snapshot.error.toString(),
      //               );
      //           }
      //           if (!snapshot.hasData) {
      //             return Text('');
      //           }

      //           CombinedEventData combineEvent = snapshot.data!;

      //         },
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
