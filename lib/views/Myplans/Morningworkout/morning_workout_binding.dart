import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/Myplans/Morningworkout/morning_workout_controller.dart';
class MornningworkoutBinding extends Bindings{
 @ override
  void dependencies() {
     Get.lazyPut(() => MornningworkoutController());
  }
}