class Events {
  final String eventId;
  final String address;
  final String capacity;
  final String date;
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
    return Events(
        eventId: map['id'],
        address: map['address'],
        capacity: map['capacity'],
        date: map['date'],
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
