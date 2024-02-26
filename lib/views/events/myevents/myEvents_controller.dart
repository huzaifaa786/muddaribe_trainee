import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mudarribe_trainee/api/attenddee_api.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/event_other_data.dart';
import 'package:mudarribe_trainee/models/trainer.dart';

class MyEventController {
  final attendeeApi = AttendeeApi();

  Future<List<CombinedEventData>> getEventAttendeesWithInfo() async {
    List<CombinedEventData> attendeesList = [];

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('event_attendees')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('id', descending: true)
          .get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data();
        EventOtherData eventOtherData =
            await attendeeApi.geteventAttendees(data['eventId']);
        Map<String, dynamic> eventInfo = await getEventInfo(data['eventId']);
        Map<String, dynamic> trainerInfo =
            await getTrainerInfo(data['trainerId']);

        if (eventOtherData != {} && eventInfo != {} && trainerInfo != {}) {
          attendeesList.add(
            CombinedEventData(
              trainer: Trainer.fromMap(trainerInfo),
              event: Events.fromMap(eventInfo),
              eventOtherData: eventOtherData,
            ),
          );
        } else {
          print('Skipping incomplete CombinedEventData');
        }
      }

      return attendeesList;
    } catch (e) {
      print('Error fetching event attendees with info: $e');
      return []; // Return an empty list or handle the error as needed
    }
  }

  Future<Map<String, dynamic>> getTrainerInfo(String trainerId) async {
    try {
      var trainerDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(trainerId)
          .get();

      if (trainerDocument.exists) {
        return trainerDocument.data() as Map<String, dynamic>;
      } else {
        print('Trainer document not found');
        return {};
      }
    } catch (e) {
      print('Error fetching trainer information: $e');
      return {}; // Return an empty map or handle the error as needed
    }
  }

  Future<Map<String, dynamic>> getEventInfo(String eventId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('trainer_events')
          .where('id', isEqualTo: eventId)
          .where('date',
              isGreaterThan: DateTime.now().millisecondsSinceEpoch.toString())
          .where('eventStatus', isEqualTo: 'open')
          .orderBy('date', descending: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      } else {
        print('Event document not found');
        return {};
      }
    } catch (e) {
      print('Error fetching event information: $e');
      return {};
    }
  }
}
