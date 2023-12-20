class EventOtherData {
  final String totalAttendees;
  final bool isCurrentUserAttendee;

  EventOtherData({
    required this.totalAttendees,
    required this.isCurrentUserAttendee,
    
  });

  factory EventOtherData.fromMap(totalAttendes,isUserAttedee) {
    return EventOtherData(
      totalAttendees: totalAttendes,
      isCurrentUserAttendee: isUserAttedee,
    );
  }
}