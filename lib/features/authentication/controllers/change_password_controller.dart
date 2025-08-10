import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/core/utils/logging/logger.dart';
import 'package:traveling/features/authentication/presentation/widgets/showSnacker.dart';
import 'package:traveling/routes/app_routes.dart';

import '../../../core/models/response_data.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  RxBool isLoading = false.obs;

  // Method to change the password
  Future<void> changePassword(String accessToken) async {
    String newPassword = newPasswordController.text.trim();

    isLoading(true);
    final Map<String, String> requestBody = {
      'newPassword': newPassword,
    };

    try {
      // Call the new method for changing password
      final response = await _changePasswordRequest(requestBody, accessToken);

      if (response.isSuccess) {
        showSnackBar(
          title: 'Success',
          message: response.responseData['message'] ?? 'Password reset successfully.',
          icon: Icons.check_circle_outline,
          color: AppColors.primary,
        );


        Get.offAllNamed(AppRoute.loginScreen);
      } else {
        showSnackBar(
          title: 'Error',
          message: response.errorMessage ?? 'Something went wrong. Please try again later.',
          icon: Icons.error_outline_rounded,
          color: Colors.redAccent,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error: $e');
      showSnackBar(
        title: 'Error',
        message: 'An error occurred. Please try again later.',
        icon: Icons.error_outline_rounded,
        color: Colors.redAccent,
      );
    } finally {
      isLoading(false); 
    }
  }

  // New method for handling the password change request
  Future<ResponseData> _changePasswordRequest(Map<String, String> requestBody, String accessToken) async {
    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.changePassword,
        body: requestBody,
        token: 'Bearer $accessToken', // Use the Bearer token passed from OTP screen
      );
      return response;
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'An error occurred while changing the password.',
        responseData: null,
      );
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    super.onClose();
  }
}
