import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/helper/loading_helper.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';

class CategoriesController extends GetxController {
  late CollectionReference trainersCollection;
  late CollectionReference savedTrainerCollection;
  final BusyController busyController = Get.find();

  List<Trainer> trainersList = [];
  List<Trainer> serachedtrainersList = [];
  bool show = false;
  Set<Languages> lang = Set<Languages>();
  Set<Gender> selectedGenders = Set<Gender>();

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
        if (FirebaseAuth.instance.currentUser != null) {
          QuerySnapshot savedTrainerSnapshot = await FirebaseFirestore.instance
              .collection('savedTrainer')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('tarinerId', isEqualTo: trainer.id)
              .get();

          if (savedTrainerSnapshot.docs.isNotEmpty) {
            trainer.isSaved = true;
          }
        }

        double ratingSum = await fetchCompanyRatingSum(trainer.id);
        trainer.rating = ratingSum;

        return trainer;
      }).toList();

      List<Trainer> fetchedTrainers = await Future.wait(trainerFutures);

      trainersList = fetchedTrainers;
      updateTrainers(trainersList);
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

  void sortTrainersByRating() {
    trainersList.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));
    update();
  }

  void sortTrainersByNameAToZ() {
    trainersList.sort((a, b) => (a.name).compareTo(b.name));
    update();
  }

  updateTrainers(List<Trainer> trainers) {
    serachedtrainersList = trainers;
    update();
  }

  void filterTrainers(String search) {
    if (search.isNotEmpty) {
      List<Trainer> filteredTrainers = [];
      filteredTrainers = trainersList.where((trainer) {
        return trainer.name.toLowerCase().contains(search.toLowerCase());
      }).toList();
      updateTrainers(filteredTrainers);
    } else {
      Set<String> languages = {};
      Set<String> genders = {};
      for (Languages langs in lang) {
        languages.add(langs.toString().split('.').last);
      }

      for (Gender gendr in selectedGenders) {
        genders.add(gendr.toString().split('.').last);
      }

      List<Trainer> filteredTrainers = [];
      if (languages.isEmpty && genders.isEmpty) {
        filteredTrainers = trainersList;
      } else {
        filteredTrainers = trainersList.where((trainer) {
          bool languageCondition = languages.isEmpty ||
              languages.any((lang) => trainer.languages.contains(lang));

          bool genderCondition = genders.isEmpty ||
              genders.any((gender) => trainer.gender.contains(gender));

          return languageCondition && genderCondition;
        }).toList();
      }

      update();
      updateTrainers(filteredTrainers);
    }
  }

  void toggleShow() {
    show = !show;
    update();
  }
}
