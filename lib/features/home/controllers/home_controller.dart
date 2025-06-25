import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveling/core/services/auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../../book_service/presentation/screens/selete_servicer.dart';
import '../data/model/upcoming_event_model.dart';
import '../data/model/user_profile_model.dart';

class HomeScreenController extends GetxController {
  var showUpcoming = false.obs;
  Rx<ProfileResponse?> userProfile = Rx<ProfileResponse?>(null);
  RxList<dynamic> nearbyLocations = <dynamic>[].obs; // Observing locations
  RxSet<Marker> markers = <Marker>{}.obs; // Observable markers
  var isLoading = true.obs;
  // Add a variable to track if we're in service zone
  var isInServiceZone = false.obs;
  // Add a variable to track the selected location
  Rx<dynamic> selectedLocation = Rx<dynamic>(null);

  RxList<UpcomingLocation> upcomingLocations = <UpcomingLocation>[].obs;
  var isLoadingUpcoming = false.obs;  // Loading state for upcoming locations
  // Add a new variable to store the nearest location's time
  Rx<String> nearestLocationTime = ''.obs;



  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var isLocationLoading = true.obs;
  var locationPermissionGranted = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await AuthService.init();
    await getCurrentLocation();
    await Future.delayed(Duration(milliseconds: 300), () {
      fetchUserProfile();
      fetchUpcomingLocations();
    });
  }

  void toggleUpcoming() {
    showUpcoming.value = !showUpcoming.value;
  }

  // Add this method to get current location
  Future<void> getCurrentLocation() async {
    isLocationLoading.value = true;

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLoggerHelper.error('Location services are disabled.');
        _setDefaultLocation();
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppLoggerHelper.error('Location permissions are denied');
          _setDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppLoggerHelper.error('Location permissions are permanently denied');
        _setDefaultLocation();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;
      locationPermissionGranted.value = true;

      AppLoggerHelper.info('Current location: ${position.latitude}, ${position.longitude}');

    } catch (e) {
      AppLoggerHelper.error('Error getting current location: $e');
      _setDefaultLocation();
    } finally {
      isLocationLoading.value = false;
    }
  }


  // Fallback to default location if current location fails
  void _setDefaultLocation() {
    // Use registration location as fallback, or default coordinates
    currentLatitude.value = userProfile.value?.data.locationLatitude ?? 40.7128;
    currentLongitude.value = userProfile.value?.data.locationLongitude ?? -74.0060;
    locationPermissionGranted.value = false;
    isLocationLoading.value = false;
  }

  // Add method to refresh current location
  Future<void> refreshCurrentLocation() async {
    // await getCurrentLocation();
    // Optionally refresh nearby locations based on new position
    await fetchNearbyLocations();
    await fetchUpcomingLocations();
  }


  // Combined method to fetch user profile and update variables
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
      } else if (response.statusCode == 400) {
        // User not found
        AppLoggerHelper.error('User not found: ${response.errorMessage}');
      }
      else {
        AppLoggerHelper.error('Failed to load user profile: ${response.errorMessage}');

      }
    } catch (e) {
      AppLoggerHelper.error('Error occurred while fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch upcoming locations
  Future<void> fetchUpcomingLocations() async {
    isLoadingUpcoming.value = true;

    try {
      final response = await NetworkCaller().getRequest(
        AppUrls.getUpcomingLocations,
        token: "Bearer ${AuthService.token}",
      );

      if (response.isSuccess) {
        List<dynamic> data = response.responseData['data'];

        log('Upcoming Locations: $data');
        upcomingLocations.value = data
            .map((location) => UpcomingLocation.fromJson(location))
            .toList();
        AppLoggerHelper.info('Upcoming locations fetched successfully');
      } else {
        AppLoggerHelper.error('Failed to load upcoming locations: ${response.errorMessage}');
      }
    } catch (e) {
      AppLoggerHelper.error('Error occurred while fetching upcoming locations: $e');
    } finally {
      isLoadingUpcoming.value = false;
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

        // Create a temporary set to hold all markers
        final Set<Marker> tempMarkers = {};

        // Add user location marker first
        final userLatitude = currentLatitude.value != 0.0
            ? currentLatitude.value
            : (userProfile.value?.data.locationLatitude ?? 40.7128);

        final userLongitude = currentLongitude.value != 0.0
            ? currentLongitude.value
            : (userProfile.value?.data.locationLongitude ?? -74.0060);

        final LatLng userLocation = LatLng(userLatitude, userLongitude);

        final userMarker = Marker(
          markerId: MarkerId('user_location'),
          position: userLocation,
          infoWindow: InfoWindow(
            title: locationPermissionGranted.value
                ? 'Your Current Location'
                : 'Your Registered Location',
            snippet: "Lat: $userLatitude, Long: $userLongitude",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );

        tempMarkers.add(userMarker);
        log('Added user location marker at $userLatitude, $userLongitude');

        // Check if we have any nearby locations
        if (nearbyLocations.isEmpty) {
          // No nearby locations found, we're out of service zone
          isInServiceZone.value = false;
          log('No nearby locations found - Out of service zone');
          Get.snackbar(
            'Service Zone',
            'You are currently out of service zone. Please try again later.',
            snackPosition: SnackPosition.TOP,
          );
        } else {
          // We have nearby locations, we're in service zone
          isInServiceZone.value = true;
          // Fetch the nearest location's working hours
          var nearestLocation = nearbyLocations[0]; // Assuming the first location is the nearest
          String locationTime = nearestLocation['workingHours'] ?? '9am to 5pm'; // Adjust key if necessary
          nearestLocationTime.value = locationTime;

          // Add new markers for nearby locations
          for (var location in nearbyLocations) {
            double latitude = double.parse(location['latitude'].toString());
            double longitude = double.parse(location['longitude'].toString());
            String locationName = location['location'] ?? 'Unknown Location';

            // log('Fetched Location: $locationName - Lat: $latitude, Long: $longitude');
            // log('Location ID: ${location['id']}');

            final marker = Marker(
              markerId: MarkerId(location['id'].toString()),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: locationName,
                snippet: "Lat: $latitude, Long: $longitude",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              onTap: () {
                // When marker is tapped, set this location as selected
                selectedLocation.value = location;
                // log('Selected location ID: ${location['id']}');
              },
            );
            tempMarkers.add(marker);
          }
        }

        // Update markers all at once to trigger a single rebuild
        markers.value = tempMarkers;

        log('Total Markers: ${markers.length}');
        AppLoggerHelper.info('Nearby locations fetched successfully');
      } else {
        // API error, assume we're out of service zone
        isInServiceZone.value = false;
        AppLoggerHelper.error(
            'Failed to load locations: ${response.errorMessage}');
      }
    } catch (e) {
      // Error occurred, assume we're out of service zone
      isInServiceZone.value = false;
      AppLoggerHelper.error(
          'Error occurred while fetching nearby locations: $e');
    }
  }

  // Method to navigate to select service with the selected location ID
  void navigateToSelectService() {
    if (selectedLocation.value != null) {
      final userID = selectedLocation.value['userId'];
      log('Navigating to SelectServiceView with User ID: $userID');
      Get.to(() => SelectServiceView(userID: userID));
    } else {
      log('No location selected. Please select a location marker first.');
      // You could show a snackbar or toast here to inform the user
      Get.snackbar(
        'No Location Selected',
        'Please select a location on the map first',
      );
    }
  }
}
