import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/trainee_profile/report/report_problem_contoller.dart';

class ReportProblemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportProblemController());
  }
}
