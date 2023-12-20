import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mudarribe_trainee/exceptions/database_api_exception.dart';
import 'package:mudarribe_trainee/models/trainer_report.dart';

class ReportApi {
  static final _firestore = FirebaseFirestore.instance;
  final CollectionReference _trainerEventCollection =
      _firestore.collection("trainer_reports");

  Future<void> createReport(TraineeReport event) async {
    try {
      await _trainerEventCollection.doc(event.id).set(event.toJson());
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create event',
        message: e.message,
      );
    }
  }

  Future<List<TraineeReport>> getTrainerEvents(traineeId) async {
   
    try {
      final result = await _trainerEventCollection.get();

      final events = result.docs
          .map(
            (e) => TraineeReport.fromJson(e.data()! as Map<String, dynamic>),
          )
          .where((item) => item.traineeId == traineeId)
          .toList();

      return events;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get events',
        message: e.message,
      );
    }
  }
}
