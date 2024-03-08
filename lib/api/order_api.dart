import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/exceptions/database_api_exception.dart';
import 'package:mudarribe_trainee/models/combine_order.dart';
import 'package:mudarribe_trainee/models/combined_file.dart';
import 'package:mudarribe_trainee/models/order.dart';
import 'package:mudarribe_trainee/models/package_data_combined.dart';
import 'package:mudarribe_trainee/models/plan.dart';
import 'package:mudarribe_trainee/models/plan_file.dart';
import 'package:mudarribe_trainee/models/post_data_combined.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_package.dart';

class OrderApi {
  static Future<List<CombinedOrderData>> fetchTraineeOrders(
      String category) async {
    final traineeId = FirebaseAuth.instance.currentUser!.uid;

    List<CombinedOrderData> combineOrders = [];
    QuerySnapshot orders = await FirebaseFirestore.instance
        .collection('orders')
        .where("userId", isEqualTo: traineeId)
        .get();

    if (orders.docs.isNotEmpty) {
      for (var orderDoc in orders.docs) {
        if (orderDoc.exists) {
          Map<String, dynamic> orderData =
              orderDoc.data()! as Map<String, dynamic>;
          TrainerOrder order = TrainerOrder.fromJson(orderData);
          DocumentSnapshot trainerSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(order.trainerId)
              .get();
          Map<String, dynamic> trainerData =
              trainerSnapshot.data()! as Map<String, dynamic>;
          Trainer trainer = Trainer.fromMap(trainerData);

          if (order.type == 'My_Plan') {
            DocumentSnapshot personalPlanSnapshot = await FirebaseFirestore
                .instance
                .collection('personalplans')
                .doc(order.planId)
                .get();
            Map<String, dynamic> personalPlanData =
                personalPlanSnapshot.data()! as Map<String, dynamic>;

            TrainerPackage personalPlan =
                TrainerPackage.fromJson(personalPlanData);
            if (personalPlan.category == category ||
                personalPlan.category == 'excercise&nutrition') {
              combineOrders.add(CombinedOrderData(
                  order: order,
                  combinedPackageData: CombinedPackageData(
                      trainer: trainer, package: personalPlan)));
            }
          } else {
            DocumentSnapshot pacakageSnapshot = await FirebaseFirestore.instance
                .collection('packages')
                .doc(order.planId)
                .get();

            Map<String, dynamic> pacakageData =
                pacakageSnapshot.data()! as Map<String, dynamic>;

            TrainerPackage package = TrainerPackage.fromJson(pacakageData);
            if (package.category == category ||
                package.category == 'excercise&nutrition') {
              combineOrders.add(CombinedOrderData(
                  order: order,
                  combinedPackageData:
                      CombinedPackageData(trainer: trainer, package: package)));
            }
          }
        }
      }
    }
    return combineOrders;
  }

  static Future<List<CombinedOrderData>> fetchOrders() async {
    final traineeId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch orders
    QuerySnapshot orders = await FirebaseFirestore.instance
        .collection('orders')
        .where("userId", isEqualTo: traineeId)
        .orderBy('orderId', descending: true)
        .get();

    List<Future<CombinedOrderData>> futures = [];

    for (var orderDoc in orders.docs) {
      if (orderDoc.exists) {
        Map<String, dynamic> orderData =
            orderDoc.data()! as Map<String, dynamic>;
        TrainerOrder order = TrainerOrder.fromJson(orderData);

        // Fetch trainer data
        Future<DocumentSnapshot> trainerSnapshot = FirebaseFirestore.instance
            .collection('users')
            .doc(order.trainerId)
            .get();

        // Fetch package data (either personal plan or general package)
        Future<DocumentSnapshot> packageSnapshot = order.type == 'My_Plan'
            ? FirebaseFirestore.instance
                .collection('personalplans')
                .doc(order.planId)
                .get()
            : FirebaseFirestore.instance
                .collection('packages')
                .doc(order.planId)
                .get();

        futures.add(Future.wait([trainerSnapshot, packageSnapshot])
            .then((List<DocumentSnapshot> snapshots) {
          Map<String, dynamic> trainerData =
              snapshots[0].data()! as Map<String, dynamic>;
          Trainer trainer = Trainer.fromMap(trainerData);

          Map<String, dynamic> packageData =
              snapshots[1].data()! as Map<String, dynamic>;

          TrainerPackage package = order.type == 'My_Plan'
              ? TrainerPackage.fromJson(packageData)
              : TrainerPackage.fromJson(packageData);

          return CombinedOrderData(
              order: order,
              combinedPackageData:
                  CombinedPackageData(trainer: trainer, package: package));
        }));
      }
    }

    // Wait for all futures to complete
    List<CombinedOrderData> combineOrders = await Future.wait(futures);

    return combineOrders;
  }

  static Future<List<CombinedTraineeFileData>> getPlansByOrder(category) async {
    final _firestore = FirebaseFirestore.instance;
    final CollectionReference _trainerplanCollection =
        _firestore.collection("plans");
    final CollectionReference _trainerFilesCollection =
        _firestore.collection("trainer_plan_files");
    final CollectionReference _trainerCollection =
        _firestore.collection("users");

    try {
      print(FirebaseAuth.instance.currentUser!.uid);
      final result = await _trainerplanCollection
          .where('category', isEqualTo: category)
          .where('traineeId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('id', descending: true)
          .get();

      // List<Plan> plans = [];
      List<CombinedTraineeFileData> combinedata = [];

      await Future.wait(result.docs.map((userPlan) async {
        var datadoc = userPlan.data() as Map<String, dynamic>;

        final fileAndVideoResult = await _trainerFilesCollection
            .where('planId', isEqualTo: datadoc['id'])
            .where('fileType', whereIn: ['pdf', 'mp4']).get();

        String fileLength = '0';
        String videoLength = '0';

        for (var fileResult in fileAndVideoResult.docs) {
          if (fileResult['fileType'] == 'pdf') {
            fileLength = (int.parse(fileLength) + 1).toString();
          } else if (fileResult['fileType'] == 'mp4') {
            videoLength = (int.parse(videoLength) + 1).toString();
          }
        }

        datadoc['description'] = '${'files'.tr} ' +
            '$fileLength ,' +
            '${'videos'.tr} ' +
            '$videoLength';

        DocumentSnapshot trainerSnapshot =
            await _trainerCollection.doc(datadoc['trainerId']).get();
        Map<String, dynamic> trainerData =
            trainerSnapshot.data()! as Map<String, dynamic>;
        Trainer trainer = Trainer.fromMap(trainerData);
        combinedata.add(CombinedTraineeFileData(
            trainer: trainer, plan: Plan.fromJson(datadoc)));
      }));
    combinedata.sort((a, b) => b.plan.id.compareTo(a.plan.id));

      return combinedata;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to Get Plans',
        message: e.message,
      );
    }
  }

  // static Future<List<Plan>> getPlansByOrder(orderId, category) async {
  //   final _firestore = FirebaseFirestore.instance;
  //   final CollectionReference _trainerplanCollection =
  //       _firestore.collection("plans");
  //   final CollectionReference _trainerFilesCollection =
  //       _firestore.collection("trainer_plan_files");
  //   final CollectionReference _userPlanCollection =
  //       _firestore.collection("user_personal_plans");
  //   try {
  //     final result =
  //         await _userPlanCollection.where('orderId', isEqualTo: orderId).get();

  //     List<Plan> plans = [];
  //     for (var userPlan in result.docs) {
  //       var datadoc = userPlan.data() as Map<String, dynamic>;
  //       final doc = await _trainerplanCollection.doc(datadoc['planId']).get();

  //       String fileLength = '0';
  //       String videoLength = '0';
  //       final planData = doc.data() as Map<String, dynamic>;

  //       final fileResult = await _trainerFilesCollection
  //           .where('planId', isEqualTo: doc.id)
  //           .where('fileType', isEqualTo: 'pdf')
  //           .get();

  //       final videoResult = await _trainerFilesCollection
  //           .where('planId', isEqualTo: doc.id)
  //           .where('fileType', isEqualTo: 'mp4')
  //           .get();
  //       if (fileResult.docs.isNotEmpty || videoResult.docs.isNotEmpty) {
  //         fileLength = fileResult.docs.length.toString();
  //         videoLength = videoResult.docs.length.toString();
  //       }
  //       planData['description'] = '$fileLength Files ,$videoLength videos';
  //       // if (planData['category'] == category) {
  //       plans.add(Plan.fromJson(planData));
  //       // }
  //     }

  //     return plans;
  //   } on PlatformException catch (e) {
  //     throw DatabaseApiException(
  //       title: 'Failed to Get Plans',
  //       message: e.message,
  //     );
  //   }
  // }

  static Future<List<PlanFile>> getFilesByPlanId(planId) async {
    try {
      print(planId);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('trainer_plan_files')
          .where('planId', isEqualTo: planId)
          .orderBy('id', descending: true)
          .get();
      List<PlanFile> files = querySnapshot.docs
          .map((doc) => PlanFile.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      print('$files files');

      return files;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get Files by Plan ID',
        message: e.message,
      );
    }
  }
}
