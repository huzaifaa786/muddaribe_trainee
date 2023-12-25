import 'package:mudarribe_trainee/models/notification.dart';
import 'package:mudarribe_trainee/models/trainer.dart';

class CombinedTrainerNotification {
  final Trainer trainer;
  final Notifications notification;

  CombinedTrainerNotification({required this.trainer, required this.notification});
}