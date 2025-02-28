import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:traveling/core/services/location.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  void navigateToHomeScreen() {
    Get.offAllNamed(
      AppRoute.loginScreen,
    );
  }

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = '......'.obs;

  final LocationService _locationService = LocationService();

  Future<void> fetchLocationForIOS() async {
    await _fetchLocation();
  }

  Future<void> fetchLocationForAndroid() async {
    await _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Instead of just logging, show a dialog to enable location services
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

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      debugPrint('Latitude: ${latitude.value}');
      debugPrint('Longitude: ${longitude.value}');

      // Reverse geocode to get address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        String fullAddress = [
          placemark.subLocality,
          placemark.locality,
          placemark.country,
        ].where((element) => element != null && element.isNotEmpty).join(', ');

        _locationService.setLocation(
            latitude.value, longitude.value, fullAddress);
        navigateToHomeScreen();
        debugPrint('Address: $fullAddress');
      } else {
        debugPrint('No placemarks found for the location.');
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  // Show dialog when location services are disabled
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

  // Show dialog when location permission is denied
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

  // Show dialog when location permission is permanently denied
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

  @override
  void onInit() {
    super.onInit();
    if (Platform.isIOS) {
      fetchLocationForIOS();
    } else if (Platform.isAndroid) {
      fetchLocationForAndroid();
    }
  }
}

