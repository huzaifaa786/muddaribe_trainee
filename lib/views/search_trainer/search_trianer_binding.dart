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
  Languages lang = Languages.English;
  Gender gender = Gender.male;
  Categories category = Categories.body_Building;
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
      String gendr = gender.toString().split('.').last;
      String cate;
      String language;
      if (category == Categories.body_Building) {
        cate = 'Body Building';
      } else if (category == Categories.medical_Fitness) {
        cate = 'Medical Fitness';
      } else {
        cate = category.toString().split('.').last;
      }
      print(cate);
      language = lang.toString().split('.').last;
      List<Trainer> filteredTrainers = allItems.where((trainer) {
        return trainer.gender == gendr &&
            trainer.category.contains(cate) &&
            trainer.languages.contains(language);
      }).toList();

      updateTrainers(filteredTrainers);
    }
  }
}
