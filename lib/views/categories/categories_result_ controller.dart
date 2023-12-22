import 'package:cloud_firestore/cloud_firestore.dart';
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
        DocumentSnapshot<Map<String, dynamic>> savedTrainerSnapshot =
            await FirebaseFirestore.instance
                .collection('savedTrainer')
                .doc(trainer.id)
                .get();
        if (savedTrainerSnapshot.exists) {
          trainer.isSaved = true;
        }
        fetchedTrainers.add(trainer);
      }

      trainersList = fetchedTrainers;
      update();
    } catch (error) {
      print("Error fetching trainers: $error");
    }
    busyController.setBusy(false);
  }
}
