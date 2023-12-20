import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/trainer/profile/profile_controller.dart';
class Trainerprofilebinding extends Bindings {
 @override
  void dependencies() {
     Get.lazyPut(() => TrainerprofileController());
  }
}