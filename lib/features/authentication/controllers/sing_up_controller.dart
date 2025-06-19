import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/routes/app_routes.dart';

import '../../../core/services/Auth_service.dart';
import '../../../core/services/location.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../../splash_screen/controllers/splash_controller.dart';
import '../presentation/widgets/showSnacker.dart';
import 'location_controller.dart';

class SingUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController addressController = TextEditingController();


  RxBool isLoading = false.obs;


  void signUp() async {
    final userName = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPassController.text.trim();
    final LocationService _locationService = LocationService();

    // Retrieve the location data from LocationService
    final latitude = _locationService.gLatitude;
    final longitude = _locationService.gLongitude;
    final address = _locationService.gAddress;
    log('Latitude: $latitude, Longitude: $longitude, Address: $address');  // Log the location data

    // Check if passwords match
    if (password != confirmPassword) {
      showSnackBar(
        title: 'Password Mismatch',
        message: 'Passwords do not match. Please re-enter them.',
        icon: Icons.error_outline_rounded,
        color: Colors.redAccent,
      );
      return;
    }
    // Prepare request body
    final Map<String, dynamic> requestBody = {
      'userName': userName,
      'email': email,
      'password': password,
      'location': address,
      'locationLatitude': latitude,
      'locationLongitude': longitude,
      // Add other fields if necessary
    };

    try {
      isLoading.value = true;

      // Make API request
      final response = await NetworkCaller().postRequest(AppUrls.singUp, body: requestBody);

      if (response.isSuccess) {
        // If success, extract token and other necessary data
        String? token = response.responseData['data']['accessToken'];

        if (token != null) {
          await AuthService.saveToken(token); // Save the token for further API calls
        }

        // Show success message
        showSnackBar(
          title: 'Success',
          message: 'User registered successfully',
          icon: Icons.check_circle,
          color: Colors.green,
        );
        log('Signup Response: ${response.responseData}');
        // Redirect to login page or dashboard
        Get.toNamed(AppRoute.loginScreen);

      } else {
        // If email already exists or some other error
        if (response.statusCode == 409) {
          showSnackBar(
            title: 'Email Already Exists',
            message: 'This email is already registered. Please try another one.',
            icon: Icons.error_outline_rounded,
            color: Colors.redAccent,
          );
        } else {
          // Handle other errors from the API
          showSnackBar(
            title: 'Error',
            message: response.errorMessage ?? 'An error occurred. Please try again later.',
            icon: Icons.error_outline_rounded,
            color: Colors.redAccent,
          );
        }
      }
    } catch (e) {
      // Catch any errors during the API call
      AppLoggerHelper.error('SignUp Error: $e');
      showSnackBar(
        title: 'Error',
        message: 'Something went wrong. Please try again later.',
        icon: Icons.error_outline_rounded,
        color: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
