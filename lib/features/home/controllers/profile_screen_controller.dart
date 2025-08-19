import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/features/authentication/presentation/widgets/showSnacker.dart';
import 'package:traveling/routes/app_routes.dart';


class ProfileScreenController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      final response = await NetworkCaller().deleteRequest(
        AppUrls.deleteProfile,
        "Bearer ${AuthService.token}",
      );
      log("Status Code: ${response.statusCode}");
      isLoading.value = false;
      if (response.isSuccess) {
        log("Status Code: ${response.statusCode}");
        showSnackBar(
          title: "Success",
          message: "Your account has been deleted successfully",
          icon: Icons.check_circle_outline,
          color: AppColors.primary,
        );
        Get.offAllNamed(AppRoute.loginScreen);
      } else {
        if (response.statusCode == 404) {
          String errorMessage = response.responseData['message'] ?? 'User not found';
          await AuthService.logoutUser();
          Get.offAllNamed(AppRoute.loginScreen);
          showSnackBar(
            title: "Error",
            message: errorMessage,
            icon: Icons.error_outlined,
            color: Colors.redAccent,
          );
        }
      }
    } catch (e) {
      isLoading.value = false;
      showSnackBar(
        title: "Error",
        message: "An error occurred while deleting your account",
        icon: Icons.error_outline_rounded,
        color: Colors.redAccent,
      );
      print("Error deleting account: $e");
    }
  }
}

