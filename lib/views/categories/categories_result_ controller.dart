import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/helper/loading_helper.dart';
import 'package:mudarribe_trainee/models/trainer.dart';

class CategoriesController extends GetxController {
  late CollectionReference trainersCollection;
  late CollectionReference savedTrainerCollection;
  final BusyController busyController = Get.find();

  List<Trainer> trainersList = [];

  // Assuming you're setting these collections somewhere in your code...

  fetchDataFromFirebase(String category) async {
    busyController.setBusy(true);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await trainersCollection
              .where('userType', isEqualTo: 'trainer')
              .where('categories', arrayContains: category)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      List<Trainer> fetchedTrainers = [];

      for (var doc in querySnapshot.docs) {
        Trainer trainer = Trainer.fromMap(doc.data());
        QuerySnapshot savedTrainerSnapshot = await FirebaseFirestore.instance
            .collection('savedTrainer')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('tarinerId', isEqualTo: trainer.id)
            .get();
        if (savedTrainerSnapshot.docs.isNotEmpty) {
          trainer.isSaved = true;
        }
        double ratingSum = await fetchCompanyRatingSum(trainer.id);
        trainer.rating = ratingSum;
        fetchedTrainers.add(trainer);
      }

      trainersList = fetchedTrainers;
      update();
    } catch (error) {
      print("Error fetching trainers: $error");
    }
    busyController.setBusy(false);
  }

  Future<double> fetchCompanyRatingSum(String trainerId) async {
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
