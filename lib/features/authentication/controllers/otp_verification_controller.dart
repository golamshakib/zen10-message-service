import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordTEController = TextEditingController();

  var isResendEnabled = false.obs;
  var start = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

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

  // void resendOtp(String email) async {
  //   startTimer(); // Restart the timer
  //   final Map<String, String> requestBody = {
  //     'email': email,
  //   };
  //   final response = await NetworkCaller()
  //       .postRequest(AppUrls.forgotPass, body: requestBody);
  //   if (response.isSuccess) {
  //     EasyLoading.showError('Please Check Your Email');
  //   } else {
  //     EasyLoading.showError('Failed to send reset email. Please try again.');
  //   }
  // }

  // Future<void> otpSend(String email) async {
  //   final Map<String, String> requestBody = {
  //     'email': email.trim(),
  //     'otpCode': otpController.text.trim(),
  //     'password': newPasswordTEController.text.trim(),
  //   };

  //   if (otpController.text.isEmpty || otpController.text.length != 6) {
  //     Get.snackbar(
  //       'Invalid OTP',
  //       'Please enter a valid 6-digit OTP',
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: AppColors.primary,
  //       colorText: AppColors.white,
  //       borderRadius: 10,
  //       margin: EdgeInsets.all(16.sp),
  //       animationDuration: const Duration(milliseconds: 300),
  //       duration: const Duration(seconds: 3),
  //     );
  //     return;
  //   }

  //   if (newPasswordTEController.text.isEmpty ||
  //       newPasswordTEController.text.length < 8) {
  //     Get.snackbar(
  //       'Invalid Password',
  //       'Your password must be at least 8 characters long.',
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: AppColors.primary,
  //       colorText: AppColors.white,
  //       borderRadius: 10,
  //       margin: EdgeInsets.all(16.sp),
  //       animationDuration: const Duration(milliseconds: 300),
  //       duration: const Duration(seconds: 3),
  //     );
  //     return;
  //   }

  //   try {
  //     EasyLoading.show();
  //     final response =
  //         await NetworkCaller().postRequest(AppUrls.otp, body: requestBody);
  //     if (response.isSuccess) {
  //       Get.offNamed('/loginScreen');
  //     } else {
  //       Get.snackbar(
  //         'Otp Failed',
  //         'Invalid otp response.',
  //         snackPosition: SnackPosition.TOP,
  //         padding: const EdgeInsets.all(15),
  //         backgroundColor: AppColors.primary,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Something went wrong. Please try again later.',
  //       padding: const EdgeInsets.all(15),
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: AppColors.primary,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }
}