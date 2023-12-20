import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}