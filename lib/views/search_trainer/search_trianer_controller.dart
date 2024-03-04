// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/helper/loading_helper.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';

class TSearchController extends GetxController {
  static TSearchController get instance => Get.find();
  final BusyController busyController = Get.find();
  List<Trainer> allItems = [];
  List<Trainer> items = [];
  // Languages lang = Languages.English;
  // Gender gender = Gender.male;
  // Categories category = Categories.body_Building;
  Set<Categories> selectedCategories = Set<Categories>();
  Set<Languages> lang = Set<Languages>();
  Set<Gender> selectedGenders = Set<Gender>();

  bool show = false;

  Future<void> fetchTrainers({String? query}) async {
    busyController.setBusy(true);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: "trainer")
          .get();

      List<Trainer> trainers =
          querySnapshot.docs.map((doc) => Trainer.fromMap(doc.data())).toList();

      List<Future<void>> fetchRatingsFutures = trainers.map((trainer) async {
        QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance
            .collection('ratings')
            .where('trainerId', isEqualTo: trainer.id)
            .get();

        double sum = ratingSnapshot.docs.fold(0.0,
            (previousValue, doc) => previousValue + (doc['rating'] ?? 0.0));

        int totalRatings = ratingSnapshot.docs.length;
        double averageRating = totalRatings > 0 ? sum / totalRatings : 0.0;

        trainer.rating = averageRating;
      }).toList();

      await Future.wait(fetchRatingsFutures);

      allItems = trainers;
      updateTrainers(trainers);
    } catch (e) {
      print("Error fetching trainers: $e");
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

  void toggleShow() {
    show = !show;
    update();
  }

  updateTrainers(List<Trainer> trainers) {
    items = trainers;
    update();
  }

  void filterTrainers(String search) {
    if (search.isNotEmpty) {
      List<Trainer> filteredTrainers = [];
      filteredTrainers = allItems.where((trainer) {
        return trainer.name.toLowerCase().contains(search.toLowerCase());
      }).toList();
      updateTrainers(filteredTrainers);
    } else {
      Set<String> categories = {};
      Set<String> languages = {};
      Set<String> genders = {};
      for (Categories cat in selectedCategories) {
        if (cat == Categories.body_Building) {
          categories.add('Body Building');
        } else if (cat == Categories.medical_Fitness) {
          categories.add('Medical Fitness');
        } else if (cat == Categories.kettle_bell) {
          categories.add('Kettle bell');
        } else if (cat == Categories.indoor_Cycling) {
          categories.add('Indoor Cycling');
        } else if (cat == Categories.animal_flow) {
          categories.add('Animal flow');
        } else {
          categories.add(cat.toString().split('.').last);
        }
      }

      for (Languages langs in lang) {
        languages.add(langs.toString().split('.').last);
      }

      for (Gender gendr in selectedGenders) {
        genders.add(gendr.toString().split('.').last);
      }

      List<Trainer> filteredTrainers = [];
      if (selectedCategories.isEmpty && languages.isEmpty && genders.isEmpty) {
        filteredTrainers = allItems;
      } else {
        filteredTrainers = allItems.where((trainer) {
          bool categoryCondition = selectedCategories.isEmpty ||
              categories.any((cat) => trainer.category.contains(cat));

          bool languageCondition = languages.isEmpty ||
              languages.any((lang) => trainer.languages.contains(lang));

          bool genderCondition = genders.isEmpty ||
              genders.any((gender) => trainer.gender.contains(gender));

          return categoryCondition && languageCondition && genderCondition;
        }).toList();
      }

      update();
      updateTrainers(filteredTrainers);
    }
  }

    void sortTrainersByRating() {
    items.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));
    update();
  }

    void sortTrainersByRatingDownToUp() {
    items.sort((a, b) => (a.rating ?? 0.0).compareTo(b.rating ?? 0.0));
    update();
  }
}
