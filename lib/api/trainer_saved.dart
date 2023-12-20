// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainerSaved {
  static trainerSaved(trainerId) async {
    print('object');
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('savedTrainer').doc(id).set({
      "id": id,
      'tarinerId': trainerId,
      "userId": FirebaseAuth.instance.currentUser!.uid,
    }).then((value) => print('success'));
  }

  static trainerUnsaved(trainerId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('savedTrainer')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('tarinerId', isEqualTo: trainerId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;
      await FirebaseFirestore.instance
          .collection('savedTrainer')
          .doc(docId)
          .delete().then((value) => print('delete'));
    }
  }
}
