import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:traveling/core/services/location.dart';
import 'package:traveling/core/services/notification_services.dart';
import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  // Remove global variables, and use LocationService instead
  final LocationService _locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
    if (Platform.isIOS) {
      fetchLocationForIOS();
    } else if (Platform.isAndroid) {
      fetchLocationForAndroid();
    }
    checkTokenValidity();
  }

  void navigateToHomeScreen() {
    log('Splash Token: ${AuthService.hasToken()}');

    if(NotificationService.isOpenedFromNotification) {
      NotificationService.isOpenedFromNotification = false;
      return;
    }
  }

  Future<void> checkTokenValidity() async {
    final response = await NetworkCaller().tokenExpireCheckRequest(
      AppUrls.fetchProfile,
      headers: {
        'Authorization': 'Bearer ${AuthService.token}'
      }, // Pass the token in the headers
    );

    if (response == null) {
      // Network error or invalid response
      Get.offAllNamed(
          AppRoute.loginScreen); // Redirect to login screen in case of error
    } else if (response == 'jwt expired') {
      // Token expired or invalid
      await AuthService.logoutUser();
      Get.offAllNamed(AppRoute.loginScreen); // Redirect to login screen
    } else {
      // Token is valid, navigate to home screen
      Get.offAllNamed(AppRoute.homeScreen);
    }
  }

  Future<void> fetchLocationForIOS() async {
    await _fetchLocation();
  }

  Future<void> fetchLocationForAndroid() async {
    await _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    log("Fetching location");
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationServicesDisabledDialog();
      return;
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied.');
        await _showLocationPermissionDeniedDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      await _showLocationPermissionPermanentlyDeniedDialog();
      return;
    }

    try {
      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Update the location in LocationService
      _locationService.setLocation(position.latitude, position.longitude, '');

      log('Latitude: ${position.latitude}');
      log('Longitude: ${position.longitude}');

      // Reverse geocode to get address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        String fullAddress = [
          placemark.subLocality,
          placemark.locality,
          placemark.country,
        ]
            .where((element) => element != null && element.isNotEmpty)
            .join(', ');

        // Update the address in LocationService
        _locationService.setLocation(position.latitude, position.longitude, fullAddress);

        log('Address: $fullAddress');
      }

      // Navigate to the appropriate screen after location fetch
      navigateToHomeScreen();
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  // Dialog methods remain the same...
  Future<void> _showLocationServicesDisabledDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
            'Location services are disabled. Please enable location services to continue.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openLocationSettings();
              // After returning from settings, check again
              await Future.delayed(const Duration(seconds: 2));
              await _fetchLocation();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showLocationPermissionDeniedDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'Location permission is required to use this feature. Please grant location permission.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _fetchLocation(); // Try again
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showLocationPermissionPermanentlyDeniedDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Location Permission Denied'),
        content: const Text(
            'Location permission is permanently denied. Please enable it from app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openAppSettings();
              // After returning from settings, check again
              await Future.delayed(const Duration(seconds: 2));
              await _fetchLocation();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
