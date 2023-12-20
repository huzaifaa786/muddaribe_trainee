import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/authentication/change_password/change_password_contoller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangepasswordController());
  }
}
