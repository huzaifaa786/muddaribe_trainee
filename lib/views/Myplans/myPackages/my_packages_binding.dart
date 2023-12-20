import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/Myplans/myPackages/my_packages_controller.dart';

class MyPackagesBinding extends Bindings{
 @ override
  void dependencies() {
     Get.lazyPut(() => MyPackagesController());
  }
}