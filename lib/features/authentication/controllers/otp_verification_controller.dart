import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/services/network_caller.dart'; // Your network service
import 'package:traveling/core/utils/constants/app_urls.dart'; // Your API URLs
import 'package:traveling/core/utils/logging/logger.dart'; // For logging errors
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/features/authentication/presentation/screens/change_password_screen.dart';

import '../presentation/widgets/showSnacker.dart'; // App Colors for UI

class OtpVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordTEController = TextEditingController();

  var isResendEnabled = false.obs;
  var start = 60.obs;
  Timer? _timer;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  // Timer for OTP resend
  void startTimer() {
    isResendEnabled.value = false;
    start.value = 300; // Set timer to 5 minutes (300 seconds)
    _timer?.cancel(); // Cancel any previous timer before starting a new one
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start.value == 0) {
        isResendEnabled.value = true;
        timer.cancel();
      } else {
        start.value--;
      }
    });
  }

  // Method to verify OTP
  Future<void> verifyOtp(String userId, String otpCode) async {
    isLoading.value = true;
    final Map<String, String> requestBody = {
      'userId': userId,
      'otpCode': otpCode,
    };

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.verifyOtp,
        body: requestBody,
      );

      if (response.isSuccess || response.statusCode == 200) {
        // Handle successful OTP verification
        showSnackBar(
          title: 'Success',
          message: 'OTP verified successfully, please reset your password.',
          icon: Icons.check_circle_outline,
          color: AppColors.primary,
        );
        String accessToken = response.responseData['data']['accessToken'];
        Get.off(() => ChangePasswordScreen(accessToken: accessToken));
      } else {
        // Handle failed OTP verification
        showSnackBar(
          title: 'OTP Verification Failed',
          message: response.errorMessage ?? 'Invalid OTP.',
          icon: Icons.error_outlined,
          color: Colors.redAccent,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error during OTP verification: $e');
      showSnackBar(
        title: 'Error',
        message: 'Something went wrong. Please try again later.',
        icon: Icons.error_outlined,
        color: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP function
  Future<void> resendOtp(String email) async {
    isLoading.value= true;
    startTimer(); // Restart the timer
    final Map<String, String> requestBody = {
      'email': email,
    };
    final response = await NetworkCaller().postRequest(AppUrls.forgotPassword, body: requestBody);

    if (response.isSuccess) {
      showSnackBar(
        title: 'Success',
        message: 'Please check your email for the new OTP.',
        icon: Icons.check_circle_outline,
        color: AppColors.primary,
      );
      String accessToken = response.responseData['data']['accessToken'];
      Get.off(() => ChangePasswordScreen(accessToken: accessToken));
    } else {
      showSnackBar(
        title: 'Error',
        message: 'Failed to send reset OTP. Please try again.',
        icon: Icons.error_outlined,
        color: Colors.redAccent,
      );
    }
    isLoading.value = false;
  }
}
