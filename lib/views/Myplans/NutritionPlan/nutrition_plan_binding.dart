import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/Myplans/NutritionPlan/nutrition_plan_controller.dart';
class NutritionplanBinding extends Bindings{
 @ override
  void dependencies() {
     Get.lazyPut(() => NutritionplanController());
  }
}