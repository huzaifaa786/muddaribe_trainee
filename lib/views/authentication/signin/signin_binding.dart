import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/authentication/signin/signin_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }
}
