import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/trainee_profile/edit_profile/editprofile_controller.dart';


class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileContoller());
  }
}
