import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mudarribe_trainee/api/attenddee_api.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_data_combined.dart';
import 'package:mudarribe_trainee/models/event_other_data.dart';
import 'package:mudarribe_trainee/models/post.dart';
import 'package:mudarribe_trainee/models/post_data_combined.dart';
import 'package:mudarribe_trainee/models/trainer.dart';

import 'package:mudarribe_trainee/models/trainer_story.dart';

class SaveApi {
  static Stream<QuerySnapshot<Object?>>? postStream = FirebaseFirestore.instance
      .collection('savedPost')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('id', descending: true)
      .snapshots();

  static Stream<QuerySnapshot<Object?>>? eventStream = FirebaseFirestore
      .instance
      .collection('savedEvent')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('id', descending: true)
      .snapshots();
  static Stream<QuerySnapshot<Object?>>? trainerStream = FirebaseFirestore
      .instance
      .collection('savedTrainer')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('id', descending: true)
      .snapshots();

  Future<List<TrainerStory>> fetchTrainerStoryData(String trainerId) async {
    final trainerSnapshot = await FirebaseFirestore.instance
        .collection('trainer_stories')
        .where('trainerId', isEqualTo: trainerId)
        .get();

    final stories = trainerSnapshot.docs
        .map(
          (e) => TrainerStory.fromJson(e.data()),
        )
        .where((item) => item.trainerId == trainerId)
        .toList();

    return stories;
  }

  static Future<List<CombinedEventData>> fetchEventsData(
      QuerySnapshot saveEventSnapshot) async {
    final attendeeApi = AttendeeApi();
    List<CombinedEventData> combinedEventData = [];
    for (var saveEvent in saveEventSnapshot.docs) {
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('trainer_events')
          .doc(saveEvent['eventId'])
          .get();
      if (eventSnapshot.exists) {
        Map<String, dynamic> eventData =
            eventSnapshot.data()! as Map<String, dynamic>;

        Events event = Events.fromMap(eventData);
        EventOtherData eventOtherData =
            await attendeeApi.geteventAttendees(event.eventId);
        DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(event.trainerId)
            .get();
        if (trainerSnapshot.exists) {
          Map<String, dynamic> trainerData =
              trainerSnapshot.data()! as Map<String, dynamic>;
          Trainer trainer = Trainer.fromMap(trainerData);
          combinedEventData.add(CombinedEventData(
              trainer: trainer, event: event, eventOtherData: eventOtherData));
        }
      }
    }
    return combinedEventData;
  }

  static Future<List<CombinedData>> fetchPostsData(
      QuerySnapshot savePostSnapshot) async {
    List<CombinedData> combinedData = [];
    for (var savePost in savePostSnapshot.docs) {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('trainer_posts')
          .doc(savePost['postId'])
          .get();
      if (postSnapshot.exists) {
        Map<String, dynamic> postData =
            postSnapshot.data()! as Map<String, dynamic>;

        Post post = Post.fromMap(postData);
        DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(post.trainerId)
            .get();
        if (trainerSnapshot.exists) {
          Map<String, dynamic> trainerData =
              trainerSnapshot.data()! as Map<String, dynamic>;
          Trainer trainer = Trainer.fromMap(trainerData);
          combinedData.add(CombinedData(trainer: trainer, post: post));
        }
      }
    }
    return combinedData;
  }

  static Future<List<Trainer>> fetchTrainerData(
      QuerySnapshot saveTrainerSnapshot) async {
    List<Trainer> trainers = [];
    for (var saveTrainer in saveTrainerSnapshot.docs) {
      DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(saveTrainer['tarinerId'])
          .get();
      if (trainerSnapshot.exists) {
        Map<String, dynamic> trainerData =
            trainerSnapshot.data() as Map<String, dynamic>;

        Trainer trainer = Trainer.fromMap(trainerData);
        double ratingSum = await fetchCompanyRatingSum(trainer.id);
        trainer.rating = ratingSum;
        trainers.add(trainer);
      }
    }
    return trainers;
  }

  static Future<double> fetchCompanyRatingSum(String trainerId) async {
    double sum = 0.0;
    int totalRatings = 0;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .where('trainerId', isEqualTo: trainerId)
          .get();

      totalRatings = querySnapshot.docs.length;

      sum = querySnapshot.docs.fold(
          0.0, (previousValue, doc) => previousValue + (doc['rating'] ?? 0.0));
    } catch (e) {
      print('Error fetching rating sum for company $trainerId: $e');
    }

    double averageRating = totalRatings > 0 ? sum / totalRatings : 0.0;
    return averageRating;
  }
}
