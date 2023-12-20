import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/Myplans/myplans_conroller.dart';

class MyplansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyplansController());
  }
}
