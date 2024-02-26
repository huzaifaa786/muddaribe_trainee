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

  Future<void> fetchDataFromFirebase(String category) async {
    busyController.setBusy(true);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await trainersCollection
              .where('userType', isEqualTo: 'trainer')
              .where('categories', arrayContains: category)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      List<Future<Trainer>> trainerFutures =
          querySnapshot.docs.map((doc) async {
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

        return trainer;
      }).toList();

      List<Trainer> fetchedTrainers = await Future.wait(trainerFutures);

      trainersList = fetchedTrainers;
      update();
    } catch (error) {
      print("Error fetching trainers: $error");
    }
    busyController.setBusy(false);
  }

  Future<double> fetchCompanyRatingSum(String trainerId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .where('trainerId', isEqualTo: trainerId)
          .get();

      int totalRatings = querySnapshot.docs.length;
      double sum = querySnapshot.docs.fold(
          0.0, (previousValue, doc) => previousValue + (doc['rating'] ?? 0.0));

      double averageRating = totalRatings > 0 ? sum / totalRatings : 0.0;
      return averageRating;
    } catch (e) {
      print('Error fetching rating sum for company $trainerId: $e');
      return 0.0; // Handle error by returning a default value
    }
  }
}
