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
      date: json['startDate'] ?? '', // Provide a default empty string if null
      location: json['location'] ?? 'Unknown Location', // Provide a default value if null
      startTime: json['startTime'] ?? '00:00', // Provide a default value if null
      endTime: json['endTime'] ?? '00:00', // Provide a default value if null
    );
  }
}
