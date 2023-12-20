import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/Myplans/planFiles/plan_files_controller.dart';
class PlanFilesBinding extends Bindings{
 @override
  void dependencies() {
     Get.lazyPut(() => PlanFilesController());
  }
}