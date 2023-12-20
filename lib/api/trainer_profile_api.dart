import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/exceptions/database_api_exception.dart';
import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/post.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_package.dart';

class TrainerProfileApi {
  static Future<Trainer> fetchTrainerData(String trainerId) async {
    final trainerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(trainerId)
        .get();

    final trainerData = trainerSnapshot.data() as Map<String, dynamic>;
    return Trainer.fromMap(trainerData);
  }

  static Future<QuerySnapshot> checkFollowing(String trainerId) async {
    return FirebaseFirestore.instance
        .collection('followed_trainers')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('trainerId', isEqualTo: trainerId)
        .get();
  }

  static fetchTrainerEvents(String trainerId) {
    var eventquery = FirebaseFirestore.instance
        .collection('trainer_events')
        .where('date',
            isGreaterThan:
                DateFormat('dd/MM/y').format(DateTime.now()).toString())
        .where('trainerId', isEqualTo: trainerId)
        .orderBy('date', descending: true);
    return eventquery;
  }

  static Future<List<Post>> getTrainerPosts(trainerId) async {
    final result =
        await FirebaseFirestore.instance.collection('trainer_posts').get();

    final posts = result.docs
        .map(
          (e) => Post.fromMap(e.data() as Map<String, dynamic>),
        )
        .where((item) => item.trainerId == trainerId)
        .toList();

    return posts;
  }

  static Future<List<TrainerPackage>> getTrainerPackages(trainerId) async {
    final result =
        await FirebaseFirestore.instance.collection('packages').get();

    final packages = result.docs
        .map(
          (e) => TrainerPackage.fromJson(e.data() as Map<String, dynamic>),
        )
        .where((item) => item.trainerId == trainerId)
        .toList();

    return packages;
  }



   static followTrainer(trainerId) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('followed_trainers').doc(id).set({
      "id": id,
      'trainerId': trainerId,
      "userId": FirebaseAuth.instance.currentUser!.uid,
    });
  }

  static unfollowTrainer(trainerId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('followed_trainers')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('trainerId', isEqualTo: trainerId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;
      await FirebaseFirestore.instance
          .collection('followed_trainers')
          .doc(docId)
          .delete();
    }
  }
}
