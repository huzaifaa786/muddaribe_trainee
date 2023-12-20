import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mudarribe_trainee/models/event_other_data.dart';

class AttendeeApi {
  Future<EventOtherData> geteventAttendees(eventId) async {
    QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('event_attendees')
        .where('eventId', isEqualTo: eventId)
        .get();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('event_attendees')
        .where('eventId', isEqualTo: eventId)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    bool isUserAttendee = userSnapshot.docs.isNotEmpty ? true : false;
    return EventOtherData.fromMap(eventSnapshot.docs.length.toString(), isUserAttendee);
  }
}
