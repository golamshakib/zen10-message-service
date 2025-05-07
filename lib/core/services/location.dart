
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Store latitude, longitude, and address
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _address = '......';

  // Getters for other classes to access
  double get gLatitude => _latitude;
  double get gLongitude => _longitude;
  String get gAddress => _address;

  // Setters to update values
  void setLocation(double lat, double lon, String address) {
    _latitude = lat;
    _longitude = lon;
    _address = address;
  }
}