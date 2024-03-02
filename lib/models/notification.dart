class Notifications {
  final String notificationId;
  final String content;
  final String orderId;
  final String planId;
  final String planName;
  final bool seen;
  final bool trainerSeen;
  final String trainerId;
  final String userId;
  final String type;

  Notifications(
      {required this.notificationId,
      required this.content,
      required this.orderId,
      required this.planId,
      required this.planName,
      required this.seen,
      required this.trainerSeen,
      required this.trainerId,
      required this.userId,
      required this.type});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      notificationId: json['id'],
      content: json['content'],
      orderId: json['orderId'] ?? '',
      planId: json['planId'] ?? '',
      planName: json['planName'] ?? '',
      seen: json['seen'] ?? false,
      trainerSeen: json['trainerSeen'] ?? false,
      trainerId: json['trainerId'],
      type: json['type'],
      userId: json['userId'] ?? '',
    );
  }
}
