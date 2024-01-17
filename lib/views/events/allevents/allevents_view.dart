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
import 'package:mudarribe_trainee/helper/loading_helper.dart';
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
  // busy
  @override
  Widget build(BuildContext context) {
    final BusyController busyController = Get.find();

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
            child: StreamBuilder<QuerySnapshot>(
              stream: EventApi.eventquery.snapshots(),
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
                  return Text(
                    '',
                    style: TextStyle(color: Colors.white),
                  );
                }

                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final eventData =
                        documents[index].data() as Map<String, dynamic>;
                    final trainerId = eventData['trainerId'];
                    Events events = Events.fromMap(eventData);

                    return StreamBuilder<CombinedEventData>(
                      stream: HomeApi.fetchCombineEventDataAsStream(
                          trainerId, events),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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

                        CombinedEventData combineEvent = snapshot.data!;
                        print(combineEvent);
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('savedEvent')
                              .where('userId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .where('eventId', isEqualTo: events.eventId)
                              .get()
                              .asStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('');
                            } else if (snapshot.hasError) {
                              return Text('');
                            } else {
                              final docs = snapshot.data!.docs;
                              bool saved = docs.isNotEmpty ? true : false;

                              return EventDetailsCard(
                                category:
                                    combineEvent.trainer.category.join(' & '),
                                name: combineEvent.trainer.name,
                                trainerId: combineEvent.trainer.id,
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
                  },
                );
              },
            )),
      ),
    );
  }
}
