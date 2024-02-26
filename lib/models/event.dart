import 'package:intl/intl.dart';

class Events {
  final String eventId;
  final String address;
  final String capacity;
  final String date;
  final String todate;
  final String endTime;
  final String eventStatus;
  final String eventType;
  final String imageUrl;
  final String price;
  final String startTime;
  final String title;
  final String trainerId;

  Events({
    required this.eventId,
    required this.address,
    required this.capacity,
    required this.date,
    required this.todate,
    required this.endTime,
    required this.eventStatus,
    required this.eventType,
    required this.imageUrl,
    required this.price,
    required this.startTime,
    required this.title,
    required this.trainerId,
  });

  factory Events.fromMap(Map<String, dynamic> map) {
    int timestamp = int.parse(map['date'].toString());
    DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('dd/MM/y').format(date1);
    return Events(
        eventId: map['id'],
        address: map['address'],
        capacity: map['capacity'],
        date: formattedDate,
        todate: map['toDate'] ?? '',
        endTime: map['endTime'],
        eventStatus: map['eventStatus'],
        eventType: map['eventType'],
        imageUrl: map['imageUrl'],
        price: map['price'],
        startTime: map['startTime'],
        title: map['title'],
        trainerId: map['trainerId']);
  }
}
