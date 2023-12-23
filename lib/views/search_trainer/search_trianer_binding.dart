// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/helper/loading_helper.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';

class TSearchController extends GetxController {
  static TSearchController get instance => Get.find();
  final BusyController busyController = Get.find();
  List<Trainer> allItems = []; // Store all trainers
  List<Trainer> items = []; // Current displayed trainers
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

      for (var trainer in trainers) {
        QuerySnapshot savedTrainerSnapshot = await FirebaseFirestore.instance
            .collection('savedTrainer')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('tarinerId', isEqualTo: trainer.id)
            .get();
        if (savedTrainerSnapshot.docs.isNotEmpty) {
          trainer.isSaved = true;
        }
      }

      allItems = trainers;
      updateTrainers(trainers);
    } catch (e) {
      print("Error fetching trainers: $e");
    }
    busyController.setBusy(false);
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
