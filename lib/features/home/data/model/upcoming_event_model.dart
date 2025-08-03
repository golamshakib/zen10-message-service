class UpcomingLocation {
  final String id;
  final String userId;
  final String startDate;
  final String endDate;
  final String location;
  final String startTime;
  final String endTime;

  UpcomingLocation({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.startTime,
    required this.endTime,
  });

  factory UpcomingLocation.fromJson(Map<String, dynamic> json) {
    return UpcomingLocation(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      location: json['location'] ?? 'Unknown Location',
      startTime: json['startTime'] ?? '00:00',
      endTime: json['endTime'] ?? '00:00',
    );
  }
}
