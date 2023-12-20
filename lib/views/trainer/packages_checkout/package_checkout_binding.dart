import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/trainer/packages_checkout/package_checkout_controller.dart';
class PackagecheckoutBinding extends Bindings{
   @ override
  void dependencies() {
  Get.lazyPut(() => Packagecheckoutcontroller());
  }
}
