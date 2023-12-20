
import 'package:mudarribe_trainee/api/report_api.dart';
import 'package:mudarribe_trainee/models/trainer_report.dart';

class ReportService {
  final _eventApi = ReportApi();

  Future<void> createReport({required TraineeReport report}) async {
    await _eventApi.createReport(report);
  }

  Future<List<TraineeReport>> getTrainerEvents({required trainerId}) async {

    return await _eventApi.getTrainerEvents(trainerId);
  }
}
