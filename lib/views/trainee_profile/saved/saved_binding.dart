import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/trainee_profile/saved/saved_controller.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SavedController());
  }
}
