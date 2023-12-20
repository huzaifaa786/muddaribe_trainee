import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/authentication/signup/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
