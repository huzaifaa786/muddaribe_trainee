import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/Myplans/myplans_conroller.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';
import 'package:mudarribe_trainee/views/trainee_profile/profile/profile_controller.dart';

class FooterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MyplansController());
    Get.lazyPut(() => ProfileController());

  }
}
