import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  var showUpcoming = false.obs; // Reactive variable
  final List<Map<String, String>> upcomingLocations = [
    {"date": "Dec 10", "location": "Phoenix"},
    {"date": "Dec 12", "location": "Philadelphia"},
    {"date": "Dec 18", "location": "St. Augustine"},
    {"date": "Dec 21", "location": "San Antonio"},
    {"date": "Dec 23", "location": "New York City"},
    {"date": "Dec 29", "location": "Chicago"},
    {"date": "Jan 04", "location": "Houston"},
  ];

  void toggleUpcoming() {
    showUpcoming.value = !showUpcoming.value;
  }
}
