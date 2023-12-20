import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/categories/categories_result_%20controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoriesController());
  }
}