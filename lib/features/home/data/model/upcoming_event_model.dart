class UpcomingLocation {
  final String id;
  final String userId;
  final String date;
  final String location;
  final String startTime;
  final String endTime;

  UpcomingLocation({
    required this.id,
    required this.userId,
    required this.date,
    required this.location,
    required this.startTime,
    required this.endTime,
  });

  factory UpcomingLocation.fromJson(Map<String, dynamic> json) {
    return UpcomingLocation(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['startDate'] ?? '',
      location: json['location'] ?? 'Unknown Location',
      startTime: json['startTime'] ?? '00:00',
      endTime: json['endTime'] ?? '00:00',
    );
  }
}
