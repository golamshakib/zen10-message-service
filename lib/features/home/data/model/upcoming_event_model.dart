class UpcomingLocation {
  final String date;
  final String location;

  UpcomingLocation({required this.date, required this.location});

  factory UpcomingLocation.fromJson(Map<String, dynamic> json) {
    return UpcomingLocation(
      date: json['date'],
      location: json['location'],
    );
  }
}
