class UpcomingLocation {
  final String date;
  final String location;
  final String startTime;
  final String endTime;

  UpcomingLocation({
    required this.date,
    required this.location,
    required this.startTime,
    required this.endTime,
  });

  factory UpcomingLocation.fromJson(Map<String, dynamic> json) {
    return UpcomingLocation(
      date: json['startDate'] ?? '',
      location: json['location'] ?? 'Unknown Location',
      startTime: json['startTime'] ?? '00:00',
      endTime: json['endTime'] ?? '00:00',
    );
  }
}
