import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/api/attenddee_api.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/event_other_data.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_story.dart';

class HomeApi {
  static var postquery = FirebaseFirestore.instance
      .collection('trainer_posts')
      .orderBy('id', descending: true);

  static var trainerquery = FirebaseFirestore.instance
      .collection('users')
      .where('userType', isEqualTo: 'trainer');

  static Future<Trainer> fetchTrainerData(String trainerId) async {
    final trainerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(trainerId)
        .get();

    final trainerData = trainerSnapshot.data() as Map<String, dynamic>;
    return Trainer.fromMap(trainerData);
  }
    static Future<CombinedEventData> fetchCombineEventData(
      String trainerId, Events event) async {
    final attendeeApi = AttendeeApi();
    final trainerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(trainerId)
        .get();

    final trainerData = trainerSnapshot.data() as Map<String, dynamic>;
    Trainer trainer = Trainer.fromMap(trainerData);
    EventOtherData eventOtherData =
        await attendeeApi.geteventAttendees(event.eventId);
    return CombinedEventData(
        trainer: trainer, event: event, eventOtherData: eventOtherData);
  }

  static Future<TrainerStory?> fetchTrainerStoryData(String trainerId) async {
    final storySnapshot = await FirebaseFirestore.instance
        .collection('trainer_stories')
        .where('trainerId', isEqualTo: trainerId)
        .limit(1)
        .get();
    if (storySnapshot.docs.isNotEmpty) {
      final storyData = storySnapshot.docs[0];

      print(storyData);
      return TrainerStory.fromJson(storyData.data() as Map<String, dynamic>);
    }
  }

  static var eventquery = FirebaseFirestore.instance
      .collection('trainer_events')
      .where('date',
          isGreaterThan:
              DateFormat('dd/MM/y').format(DateTime.now()).toString()).where('eventStatus', isEqualTo: 'open')
      .orderBy('date', descending: true)
      .limit(6);

  static var posterEventQuery = FirebaseFirestore.instance
      .collection('trainer_events')
      .where('eventType', isEqualTo: 'paid')
      .where('eventStatus', isEqualTo: 'open')
      .where('paymentStatus', isEqualTo: 'paid')
      .where('date',
          isGreaterThanOrEqualTo:
              DateFormat('dd/MM/y').format(DateTime.now()).toString())
      .orderBy('date', descending: false);

  static postSaved(postId) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('savedPost').doc(id).set({
      "id": id,
      'postId': postId,
      "userId": FirebaseAuth.instance.currentUser!.uid,
    });
  }

  static postUnsaved(postId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('savedPost')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('postId', isEqualTo: postId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;
      await FirebaseFirestore.instance
          .collection('savedPost')
          .doc(docId)
          .delete();
    }
  }
  static eventSaved(eventId) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('savedEvent').doc(id).set({
      "id": id,
      'eventId': eventId,
      "userId": FirebaseAuth.instance.currentUser!.uid,
    });
  }

  static eventUnsaved(eventId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('savedEvent')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('eventId', isEqualTo: eventId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;
      await FirebaseFirestore.instance
          .collection('savedEvent')
          .doc(docId)
          .delete();
    }
  }
}
