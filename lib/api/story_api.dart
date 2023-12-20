import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/exceptions/database_api_exception.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_story.dart';

class StoryApi {
  Future<Trainer> fetchTrainerData(String trainerId) async {
    final trainerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(trainerId)
        .get();

    final trainerData = trainerSnapshot.data() as Map<String, dynamic>;
    return Trainer.fromMap(trainerData);
  }

  Future<List<TrainerStory>> fetchTrainerStoryData(String trainerId) async {
    final trainerSnapshot = await FirebaseFirestore.instance
        .collection('trainer_stories')
        .where('trainerId', isEqualTo: trainerId)
        .get();

    final stories = trainerSnapshot.docs
        .map(
          (e) => TrainerStory.fromJson(e.data() as Map<String, dynamic>),
        )
        .where((item) => item.trainerId == trainerId)
        .toList();

    return stories;
  }

  Future<bool> deleteStory(String storyId) async {
    try {
      bool result = false;

      await FirebaseFirestore.instance
          .collection('trainer_stories')
          .doc(storyId)
          .delete()
          .whenComplete(() => result = true);

      return result;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to delete story',
        message: e.message,
      );
    }
  }
}
