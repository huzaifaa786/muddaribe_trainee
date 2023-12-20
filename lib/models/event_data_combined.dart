import 'package:mudarribe_trainee/models/event.dart';
import 'package:mudarribe_trainee/models/event_other_data.dart';
import 'package:mudarribe_trainee/models/trainer.dart';

class CombinedEventData {
  final Trainer trainer;
  final Events event;
  final EventOtherData eventOtherData;

  CombinedEventData({
    required this.trainer,
    required this.event,
    required this.eventOtherData,
  });
}
