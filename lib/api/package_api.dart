import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mudarribe_trainee/models/package_data_combined.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_package.dart';

class PackageApi {
  static Future<CombinedPackageData?> fetchPackageData(String packageId) async {
    if (packageId.isNotEmpty) {
      
    
    DocumentSnapshot packageSnapshot = await FirebaseFirestore.instance
        .collection('packages')
        .doc(packageId)
        .get();

    if (packageSnapshot.exists) {
      Map<String, dynamic> packageData =
          packageSnapshot.data()! as Map<String, dynamic>;

      TrainerPackage package = TrainerPackage.fromJson(packageData);
      DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(package.trainerId)
          .get();
      if (trainerSnapshot.exists) {
        Map<String, dynamic> trainerData =
            trainerSnapshot.data()! as Map<String, dynamic>;
        Trainer trainer = Trainer.fromMap(trainerData);
        return CombinedPackageData(trainer: trainer, package: package);
      }
    }
    }
    return null;
  }

  Future orderPlacement(String planId, String trainerID, String userID,
      String orderId, String intent, int amount) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'planId': planId,
        'trainerId': trainerID,
        'userId': userID,
        'orderId': orderId,
        'type': 'Package',
        'intent': intent,
        'amount': amount,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
