import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/trainee_profile/profile/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
