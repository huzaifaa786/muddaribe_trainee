import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mudarribe_trainee/models/post.dart';
import 'package:mudarribe_trainee/models/post_data_combined.dart';
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
            isGreaterThan: DateTime.now().millisecondsSinceEpoch.toString())
        .where('trainerId', isEqualTo: trainerId)
        .orderBy('date', descending: true);
    return eventquery;
  }

  static Future<List<Post>> getTrainerPosts(trainerId) async {
    final result =
        await FirebaseFirestore.instance.collection('trainer_posts').get();

    final posts = result.docs
        .map(
          (e) => Post.fromMap(e.data()),
        )
        .where((item) => item.trainerId == trainerId)
        .toList();

    return posts;
  }

  // static Future<List<CombinedData>> fetchTrainerPostsData(trainerId) async {
  //   final savePostSnapshot = await FirebaseFirestore.instance
  //       .collection('trainer_posts')
  //       .where("trainerId", isEqualTo: trainerId).orderBy('id', descending: true)
  //       .get();
  //   List<CombinedData> combinedData = [];
  //   for (var savePost in savePostSnapshot.docs) {
  //     DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
  //         .collection('trainer_posts')
  //         .doc(savePost['id'])
  //         .get();
  //     if (postSnapshot.exists) {
  //       Map<String, dynamic> postData =
  //           postSnapshot.data()! as Map<String, dynamic>;

  //       Post post = Post.fromMap(postData);
  //       DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(post.trainerId)
  //           .get();
  //       if (trainerSnapshot.exists) {
  //         Map<String, dynamic> trainerData =
  //             trainerSnapshot.data()! as Map<String, dynamic>;
  //         Trainer trainer = Trainer.fromMap(trainerData);
  //         combinedData.add(CombinedData(trainer: trainer, post: post));
  //       }
  //     }
  //   }
  //   return combinedData;
  // }

  static Future<List<CombinedData>> fetchTrainerPostsData(trainerId) async {
    final QuerySnapshot savePostSnapshot = await FirebaseFirestore.instance
        .collection('trainer_posts')
        .where("trainerId", isEqualTo: trainerId)
        .orderBy('id', descending: true)
        // .limit(50) // Adjust the limit based on your data size
        .get();

    List<Future<CombinedData?>> fetchTasks =
        savePostSnapshot.docs.map((savePost) async {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('trainer_posts')
          .doc(savePost['id'])
          .get();

      if (postSnapshot.exists) {
        Post post = Post.fromMap(postSnapshot.data()! as Map<String, dynamic>);

        DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(post.trainerId)
            .get();

        if (trainerSnapshot.exists) {
          Trainer trainer =
              Trainer.fromMap(trainerSnapshot.data()! as Map<String, dynamic>);
          return CombinedData(trainer: trainer, post: post);
        }
      }
      return null;
    }).toList();

    List<CombinedData?> results = await Future.wait(fetchTasks);

    // Remove null values (failed fetches) from the results
    return results.where((data) => data != null).toList().cast<CombinedData>();
  }

  static Future<List<TrainerPackage>> getTrainerPackages(trainerId) async {
    final result =
        await FirebaseFirestore.instance.collection('packages').get();

    final packages = result.docs
        .map(
          (e) => TrainerPackage.fromJson(e.data()),
        )
        .where((item) => item.trainerId == trainerId)
        .toList();

    return packages;
  }

  static followTrainer(trainerId) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection('followed_trainers')
        .doc(id)
        .set({
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
