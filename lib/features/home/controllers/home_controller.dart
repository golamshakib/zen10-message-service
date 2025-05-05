import 'dart:developer';
import 'package:get/get.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/core/services/auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/logging/logger.dart';
import '../data/model/user_profile_model.dart';

class HomeScreenController extends GetxController {
  var showUpcoming = false.obs;
  Rx<ProfileResponse?> userProfile = Rx<ProfileResponse?>(null);

  final List<Map<String, String>> upcomingLocations = [
    {"date": "Dec 10", "location": "Phoenix"},
    {"date": "Dec 12", "location": "Philadelphia"},
    {"date": "Dec 18", "location": "St. Augustine"},
    {"date": "Dec 21", "location": "San Antonio"},
    {"date": "Dec 23", "location": "New York City"},
    {"date": "Dec 29", "location": "Chicago"},
    {"date": "Jan 04", "location": "Houston"},
  ];

  @override
  void onInit() async {
    super.onInit();
    await AuthService.init();
    await Future.delayed(Duration(milliseconds: 300), () {
      fetchUserProfile();
    });
  }

  void toggleUpcoming() {
    showUpcoming.value = !showUpcoming.value;
  }

  // Combined method to fetch user profile and update variables
  Future<void> fetchUserProfile() async {
    if (AuthService.token == null) {
      AppLoggerHelper.error('Token is not available!');
      return;
    }

    try {
      final response = await NetworkCaller().getRequest(
        AppUrls.fetchProfile,
        token: "Bearer ${AuthService.token}",
      );
      log(response.responseData.toString());

      if (response.isSuccess) {
        userProfile.value = ProfileResponse.fromJson(response.responseData);
        AppLoggerHelper.info('User profile fetched successfully');
      } else {
        AppLoggerHelper.error('Failed to load user profile: ${response.errorMessage}');
      }
    } catch (e) {
      // Catching any errors during the API call
      AppLoggerHelper.error('Error occurred while fetching user profile: $e');
    }
  }
}
