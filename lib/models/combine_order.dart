import 'package:mudarribe_trainee/models/app_user.dart';
import 'package:mudarribe_trainee/models/order.dart';
import 'package:mudarribe_trainee/models/package_data_combined.dart';
import 'package:mudarribe_trainee/models/trainer.dart';

class CombinedOrderData {
  final TrainerOrder order;
  final CombinedPackageData? combinedPackageData;

  CombinedOrderData({
    required this.order,
    required this.combinedPackageData,
  });
}
