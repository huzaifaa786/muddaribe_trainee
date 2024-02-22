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
        .orderBy('id', descending: true)
        .get();

    List<String> trainerIds =
        notificationDocs.docs.map((doc) => doc['trainerId'] as String).toList();

    Map<String, Trainer> trainersMap = {};

    await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: trainerIds)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        trainersMap[doc.id] =
            Trainer.fromMap(doc.data() as Map<String, dynamic>);
      });
    });

    combinedData = notificationDocs.docs.map((notificationDoc) {
      final notificationData = notificationDoc.data() as Map<String, dynamic>;
      final notification = Notifications.fromJson(notificationData);

      final trainerId = notificationData['trainerId'];
      final trainer = trainersMap[trainerId]!;

      return CombinedTrainerNotification(
        trainer: trainer,
        notification: notification,
      );
    }).toList();

    return combinedData;
  }
}
