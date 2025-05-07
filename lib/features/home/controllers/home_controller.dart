import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveling/core/services/auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../data/model/user_profile_model.dart';

class HomeScreenController extends GetxController {
  var showUpcoming = false.obs;
  Rx<ProfileResponse?> userProfile = Rx<ProfileResponse?>(null);
  RxList<dynamic> nearbyLocations = <dynamic>[].obs;  // Observing locations
  RxSet<Marker> markers = <Marker>{}.obs;  // Observable markers

  @override
  void onInit() async {
    super.onInit();
    await AuthService.init();
    await Future.delayed(Duration(milliseconds: 300), () {
      fetchUserProfile();
      fetchNearbyLocations();  // Fetch locations on init
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
      AppLoggerHelper.error('Error occurred while fetching user profile: $e');
    }
  }

  // Fetch nearby locations from the API
  Future<void> fetchNearbyLocations() async {
    final token = AuthService.token;

    if (token == null) {
      AppLoggerHelper.error('Token is not available!');
      return;
    }

    try {
      final response = await NetworkCaller().getRequest(
        AppUrls.getNearByLocations,
        token: "Bearer $token",
      );

      if (response.isSuccess) {
        // Assuming the response contains a 'data' field with the location data
        nearbyLocations.value = response.responseData['data'];

        // Create markers for the fetched locations
        markers.clear();  // Clear existing markers
        for (var location in nearbyLocations) {
          double latitude = location['latitude'];
          double longitude = location['longitude'];
          log('Fetched Location: ${location['location']} - Lat: $latitude, Long: $longitude');

          markers.add(Marker(
            markerId: MarkerId(location['id']),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: location['location'],
              snippet: "Lat: $latitude, Long: $longitude",
            ),
          ));
        }
        AppLoggerHelper.info('Nearby locations fetched successfully');
      } else {
        AppLoggerHelper.error('Failed to load locations: ${response.errorMessage}');
      }
    } catch (e) {
      AppLoggerHelper.error('Error occurred while fetching nearby locations: $e');
    }
  }
}
