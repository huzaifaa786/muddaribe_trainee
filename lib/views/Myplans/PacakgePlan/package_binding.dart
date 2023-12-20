import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/Myplans/PacakgePlan/package_controller.dart';


class PackagePlanBinding extends Bindings{
 @override
  void dependencies() {
     Get.lazyPut(() => PackagePlanController());
  }
}