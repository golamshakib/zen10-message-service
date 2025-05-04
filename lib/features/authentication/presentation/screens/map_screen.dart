import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:traveling/features/authentication/controllers/location_controller.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController =
        Get.find<LocationController>();
    final Set<Marker> _markers = {}; // Set to hold markers

    return Obx(() {
      if (!locationController.isLocationReady.value) {
        return Center(child: CircularProgressIndicator());
      }

      LatLng initialLocation = locationController.userLocation.value;

      return Scaffold(
        appBar: AppBar(
          title: Text("Select Your Address"),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialLocation,
            zoom: 14.0,
          ),
          onMapCreated: (controller) {
            locationController.mapController = controller;
          },
          onTap: (LatLng position) async {
            // Reverse geocoding to get the address from coordinates
            List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );

            if (placemarks.isNotEmpty) {
              Placemark place = placemarks[0];
              String address =
                  "${place.name}, ${place.locality}, ${place.country}";

              // Add a marker at the tapped position
              _markers.clear();
              _markers.add(
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: position,
                  infoWindow:
                      InfoWindow(title: address), // Show address as info
                ),
              );
              // Update the camera position to the tapped location
              locationController.mapController?.moveCamera(
                CameraUpdate.newLatLng(position),
              );
              // Return the LatLng to the previous screen
              Get.back(result: position); // Return LatLng instead of address
            }
          },
          markers: _markers,
        ),
      );
    });
  }
}
