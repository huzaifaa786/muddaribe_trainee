import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mudarribe_trainee/exceptions/database_api_exception.dart';
import 'package:mudarribe_trainee/models/combine_order.dart';
import 'package:mudarribe_trainee/models/order.dart';
import 'package:mudarribe_trainee/models/package_data_combined.dart';
import 'package:mudarribe_trainee/models/plan.dart';
import 'package:mudarribe_trainee/models/plan_file.dart';
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

            combineOrders.add(CombinedOrderData(
                order: order,
                combinedPackageData: CombinedPackageData(
                    trainer: trainer, package: personalPlan)));
          } else {
            DocumentSnapshot pacakageSnapshot = await FirebaseFirestore.instance
                .collection('packages')
                .doc(order.planId)
                .get();

            Map<String, dynamic> pacakageData =
                pacakageSnapshot.data()! as Map<String, dynamic>;

            TrainerPackage package = TrainerPackage.fromJson(pacakageData);

            combineOrders.add(CombinedOrderData(
                order: order,
                combinedPackageData:
                    CombinedPackageData(trainer: trainer, package: package)));
          }
        }
      }
    }
    return combineOrders;
  }

  static Future<List<Plan>> getPlansByOrder(orderId, category) async {
    final _firestore = FirebaseFirestore.instance;
    final CollectionReference _trainerplanCollection =
        _firestore.collection("plans");
    final CollectionReference _trainerFilesCollection =
        _firestore.collection("trainer_plan_files");
    final CollectionReference _userPlanCollection =
        _firestore.collection("user_personal_plans");
    try {
      final result =
          await _userPlanCollection.where('orderId', isEqualTo: orderId).get();

      List<Plan> plans = [];
      for (var userPlan in result.docs) {
        var datadoc = userPlan.data() as Map<String, dynamic>;
        final doc = await _trainerplanCollection.doc(datadoc['planId']).get();

        String fileLength = '0';
        String videoLength = '0';
        final planData = doc.data() as Map<String, dynamic>;

        final fileResult = await _trainerFilesCollection
            .where('planId', isEqualTo: doc.id)
            .where('fileType', isEqualTo: 'pdf')
            .get();

        final videoResult = await _trainerFilesCollection
            .where('planId', isEqualTo: doc.id)
            .where('fileType', isEqualTo: 'mp4')
            .get();
        if (fileResult.docs.isNotEmpty || videoResult.docs.isNotEmpty) {
          fileLength = fileResult.docs.length.toString();
          videoLength = videoResult.docs.length.toString();
        }
        planData['description'] = '$fileLength Files ,$videoLength videos';
        // if (planData['category'] == category) {
        plans.add(Plan.fromJson(planData));
        // }
      }

      return plans;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to Get Plans',
        message: e.message,
      );
    }
  }

  static Future<List<PlanFile>> getFilesByPlanId(planId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('trainer_plan_files')
          .where('planId', isEqualTo: planId)
          .get();

      List<PlanFile> files = querySnapshot.docs
          .map((doc) => PlanFile.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return files;
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get Files by Plan ID',
        message: e.message,
      );
    }
  }
}
