import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/search_trainer/search_trianer_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TSearchController());
  }
}
