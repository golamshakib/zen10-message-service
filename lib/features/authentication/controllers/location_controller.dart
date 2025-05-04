import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class LocationController extends GetxController {
  Rx<LatLng> userLocation = const LatLng(0.0, 0.0).obs;
  GoogleMapController? mapController;
  final loc.Location _location = loc.Location();
  RxBool isLocationReady = false.obs;

  RxString userAddress = ''.obs;

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        isLocationReady.value = false;
        return;
      }
    }

    loc.PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        isLocationReady.value = false;
        return;
      }
    }

    loc.LocationData locationData = await _location.getLocation();
    userLocation.value = LatLng(
      locationData.latitude ?? 0.0,
      locationData.longitude ?? 0.0,
    );

    isLocationReady.value = true;
  }

  @override
  void onInit() async {
    await _requestLocationPermission();
    super.onInit();
  }
}
