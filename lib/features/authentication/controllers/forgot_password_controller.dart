import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/features/authentication/presentation/screens/otp_verification_screen.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import '../presentation/widgets/showSnacker.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs; // Add loading state

  bool _isValidEmail(String email) {
    return email.isNotEmpty && GetUtils.isEmail(email);
  }

  Future<void> forgotPassword() async {
    String email = emailController.text.trim();

    if (!_isValidEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      return;
    }

    errorMessage.value = ''; // Clear any previous error messages
    isLoading(true); // Set loading to true while request is being made

    final Map<String, String> requestBody = {
      'email': email,
    };

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.forgotPassword, // Ensure this URL is correct
        body: requestBody,
      );

      if (response.isSuccess) {
        // If OTP was successfully sent, navigate to OTP verification screen
        showSnackBar(
          title: 'Success',
          message: 'OTP Send Successfully',
          icon: Icons.check_circle_outline,
          color: AppColors.primary,
        );

        // Get the userId from the response or your user data
        String userId = response.responseData['data']['userId'];

        // Navigate to OTP Verification screen with email and userId
        Get.off(() => OtpVerificationScreen(email: email, userId: userId));
      } else {
        if (response.statusCode == 400) {
          String errorMessage = response.responseData['message']  ?? 'Invalid Email address';
          showSnackBar(
            title: 'Error',
            message: errorMessage,
            icon: Icons.error_outline_rounded,
            color: Colors.redAccent,
          );
        } else {
          // Handle other errors from the API
          showSnackBar(
            title: 'Error',
            message: response.errorMessage ??
                'An error occurred. Please try again later.',
            icon: Icons.error_outline_rounded,
            color: Colors.redAccent,
          );
        }
      }
    } catch (e) {
      // Handle network errors or other exceptions
      errorMessage.value = 'An error occurred. Please try again later.';
      print('Error: $e');
    } finally {
      isLoading(false); // Set loading to false after the operation is complete
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
