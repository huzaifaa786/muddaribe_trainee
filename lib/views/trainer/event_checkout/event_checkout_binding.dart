import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/trainer/event_checkout/event_checkout_controller.dart';

class EventcheckoutBinding extends Bindings{
 @ override
  void dependencies() {
  Get.lazyPut(() => EventcheckoutController());
  }
}