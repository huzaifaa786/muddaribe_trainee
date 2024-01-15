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
import 'package:mudarribe_trainee/utils/colors.dart';

class AllEventsView extends StatefulWidget {
  const AllEventsView({super.key});

  @override
  State<AllEventsView> createState() => _AllEventsViewState();
}

class _AllEventsViewState extends State<AllEventsView> {
  bool _isDataLoaded = false;
  CombinedEventData? _cachedData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'All  Events',
          style: TextStyle(
              fontSize: 20,
              color: white,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins'),
        ).translate(),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: white,
            )),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: FirestorePagination(
            bottomLoader: BasicLoader(background: false),
            initialLoader: BasicLoader(background: false),
            shrinkWrap: true,
            isLive: false,
            limit: 20,
            onEmpty: Text(
              'No event uploaded yet.',
              style: TextStyle(color: Colors.white.withOpacity(0.3)),
            ).translate(),
            viewType: ViewType.list,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            query: EventApi.eventquery,
            itemBuilder: (context, documentSnapshot, index) {
              final eventData = documentSnapshot.data() as Map<String, dynamic>;
              final trainerId = eventData['trainerId'];
              Events events = Events.fromMap(eventData);

              if (!_isDataLoaded) {
                // Only show the loading state if the data has not been loaded
                return FutureBuilder<CombinedEventData>(
                  future: _cachedData != null
                      ? Future.value(
                          _cachedData) // Use the cached data if available
                      : HomeApi.fetchCombineEventData(trainerId, events),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        snapshot.error.toString(),
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Text('');
                    }

                    _cachedData = snapshot.data; // Cache the fetched data
                    _isDataLoaded =
                        true; // Set the flag to true once the data is loaded

                    CombinedEventData combineEvent = snapshot.data!;

                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('savedEvent')
                          .where('userId',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where('eventId', isEqualTo: events.eventId)
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
                            image: combineEvent.trainer.profileImageUrl,
                            eventimg: combineEvent.event.imageUrl,
                            address: combineEvent.event.address,
                            startTime: combineEvent.event.startTime,
                            endTime: combineEvent.event.endTime,
                            date: combineEvent.event.date,
                            capacity: combineEvent.event.capacity,
                            attendees:
                                combineEvent.eventOtherData.totalAttendees,
                            isJoined: combineEvent
                                .eventOtherData.isCurrentUserAttendee,
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
                                HomeApi.eventUnsaved(events.eventId);
                              }
                            },
                          );
                        }
                      },
                    );
                  },
                );
              } else {
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('savedEvent')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('eventId', isEqualTo: events.eventId)
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
                        category: _cachedData!.trainer.category.join(' & '),
                        name: _cachedData!.trainer.name,
                        image: _cachedData!.trainer.profileImageUrl,
                        eventimg: _cachedData!.event.imageUrl,
                        address: _cachedData!.event.address,
                        startTime: _cachedData!.event.startTime,
                        endTime: _cachedData!.event.endTime,
                        date: _cachedData!.event.date,
                        capacity: _cachedData!.event.capacity,
                        attendees: _cachedData!.eventOtherData.totalAttendees,
                        isJoined:
                            _cachedData!.eventOtherData.isCurrentUserAttendee,
                        price: _cachedData!.event.price,
                        isSaved: saved,
                        eventId: _cachedData!.event.eventId,
                        onSave: () {
                          setState(() {
                            saved = !saved;
                          });
                          if (saved) {
                            HomeApi.eventSaved(events.eventId);
                          } else {
                            HomeApi.eventUnsaved(events.eventId);
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
