import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/api/attenddee_api.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/event_other_data.dart';
import 'package:mudarribe_trainee/models/trainer.dart';

class EventApi {
  static var eventquery = FirebaseFirestore.instance
      .collection('trainer_events')
      .where('date',
          isGreaterThanOrEqualTo:
              DateFormat('dd/MM/y').format(DateTime.now()).toString())
      .where('eventStatus', isEqualTo: 'open')
      .orderBy('date', descending: true);

  static Future<CombinedEventData?> fetchEventData(String eventId) async {
    final attendeeApi = AttendeeApi();
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('trainer_events')
        .doc(eventId)
        .get();

    EventOtherData eventOtherData =
        await attendeeApi.geteventAttendees(eventId);
    if (eventSnapshot.exists) {
      Map<String, dynamic> eventData =
          eventSnapshot.data()! as Map<String, dynamic>;

      Events event = Events.fromMap(eventData);
      DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(event.trainerId)
          .get();
      if (trainerSnapshot.exists) {
        Map<String, dynamic> trainerData =
            trainerSnapshot.data()! as Map<String, dynamic>;
        Trainer trainer = Trainer.fromMap(trainerData);
        return CombinedEventData(
            trainer: trainer, event: event, eventOtherData: eventOtherData);
      }
    }
    return null;
  }

  Future joinEvent(eventId) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('event_attendees').doc(id).set({
      "id": id,
      'eventId': eventId,
      "userId": FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
