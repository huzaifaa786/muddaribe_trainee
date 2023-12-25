import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mudarribe_trainee/models/combined_notification.dart';
import 'package:mudarribe_trainee/models/notification.dart';
import 'package:mudarribe_trainee/models/trainer.dart';

class NotificationApi {
  static Future<List<CombinedTrainerNotification>>
      fetchCombinedTrainerNotifications() async {
    final traineeId = FirebaseAuth.instance.currentUser!.uid;

    List<CombinedTrainerNotification> combinedData = [];
    QuerySnapshot notificationDocs = await FirebaseFirestore.instance
        .collection('notifications')
        .where("userId", isEqualTo: traineeId)
        .get();

    if (notificationDocs.docs.isNotEmpty) {
      for (var notificationDoc in notificationDocs.docs) {
        if (notificationDoc.exists) {
          Map<String, dynamic> notificationData =
              notificationDoc.data()! as Map<String, dynamic>;
          Notifications notification = Notifications.fromJson(notificationData);

          // Fetch trainer data
          DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(notification.trainerId)
              .get();
          Map<String, dynamic> trainerData =
              trainerSnapshot.data()! as Map<String, dynamic>;
          Trainer trainer = Trainer.fromMap(trainerData);

          combinedData.add(CombinedTrainerNotification(
            trainer: trainer,
            notification: notification,
          ));
        }
      }
    }

    return combinedData;
  }
}
