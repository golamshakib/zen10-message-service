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
  // Add a loading state variable at the top of the class
  var isLoading = true.obs;

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
  // Modify the fetchUserProfile method to set loading state
  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    if (AuthService.token == null) {
      AppLoggerHelper.error('Token is not available!');
      isLoading.value = false;
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
        // After fetching the user profile, fetch nearby locations
        await fetchNearbyLocations();
      } else {
        AppLoggerHelper.error('Failed to load user profile: ${response.errorMessage}');
      }
    } catch (e) {
      AppLoggerHelper.error('Error occurred while fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch nearby locations from the API
  // Modify fetchNearbyLocations to return a Future
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

        // Create a temporary set to hold all markers
        final Set<Marker> tempMarkers = {};

        // Add user location marker first
        final userLatitude = userProfile.value?.data.locationLatitude ?? 40.7128;
        final userLongitude = userProfile.value?.data.locationLongitude ?? -74.0060;
        final LatLng userLocation = LatLng(userLatitude, userLongitude);

        final userMarker = Marker(
          markerId: MarkerId('user_location'),
          position: userLocation,
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: "Lat: $userLatitude, Long: $userLongitude",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );

        tempMarkers.add(userMarker);
        log('Added user location marker at $userLatitude, $userLongitude');

        // Add new markers for nearby locations
        for (var location in nearbyLocations) {
          double latitude = double.parse(location['latitude'].toString());
          double longitude = double.parse(location['longitude'].toString());

          log('Fetched Location: ${location['location']} - Lat: $latitude, Long: $longitude');
          log('Location ID: ${location['id']}');

          final marker = Marker(
            markerId: MarkerId(location['id'].toString()),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: location['location'],
              snippet: "Lat: $latitude, Long: $longitude",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );
          tempMarkers.add(marker);
        }

        // Update markers all at once to trigger a single rebuild
        markers.value = tempMarkers;

        log('Total Markers: ${markers.length}');
        AppLoggerHelper.info('Nearby locations fetched successfully');
      } else {
        AppLoggerHelper.error('Failed to load locations: ${response.errorMessage}');
      }
    } catch (e) {
      AppLoggerHelper.error('Error occurred while fetching nearby locations: $e');
    }
  }

// Remove the _addUserLocationMarker method as we've integrated it directly into fetchNearbyLocations
}
