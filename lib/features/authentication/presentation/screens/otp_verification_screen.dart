import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/authentication/controllers/otp_verification_controller.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/logo_path.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';  // Import for loading animation widget

class OtpVerificationScreen extends StatelessWidget {
  final String email;
  final String userId;
  final otpController = Get.find<OtpVerificationController>();

  OtpVerificationScreen({super.key, required this.email, required this.userId});

  // Method to save OTP in SharedPreferences
  Future<void> saveOtpState(String otp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('OTP', otp);
  }

  // Method to get OTP from SharedPreferences
  Future<String?> getOtpState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('OTP');
  }

  // Method to clear saved OTP
  Future<void> clearOtpState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('OTP');
  }

  // Method to check OTP when app resumes
  void checkOtpOnResume() async {
    String? otp = await getOtpState();
    if (otp != null && otp.isNotEmpty) {
      otpController.otpController.text = otp;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check OTP on app resume using lifecycle method
    WidgetsBinding.instance.addObserver(AppLifecycleObserver(() {
      checkOtpOnResume();
    }));

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  LogoPath.appLogo,
                  height: 80,
                  width: 80,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'OTP Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Please enter the verification code that has been sent to your email.',
                style: TextStyle(),
              ),
              SizedBox(height: 15),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {
                  // Save OTP when changed
                  saveOtpState(value);
                },
                controller: otpController.otpController,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: AppColors.primary.withOpacity(0.1),
                  selectedFillColor: AppColors.primary.withOpacity(0.5),
                  inactiveFillColor: Colors.white,
                  activeColor: AppColors.primary,
                  selectedColor: AppColors.primary,
                  inactiveColor: Colors.grey,
                ),
                cursorColor: AppColors.primary,
                keyboardType: TextInputType.number,
                enableActiveFill: true,
              ),
              SizedBox(height: 15),
              Obx(() => Center(
                child: Text(
                  otpController.start.value == 0
                      ? 'Didn’t receive the OTP?'
                      : 'Resend OTP in ${otpController.start.value} seconds',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              )),
              SizedBox(height: 10),
              Obx(
                    () => Center(
                  child: GestureDetector(
                    onTap: otpController.isResendEnabled.value
                        ? () {
                      otpController.resendOtp(email);
                    }
                        : null,
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: otpController.isResendEnabled.value
                            ? AppColors.primary
                            : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Obx(() => otpController.isLoading.value
                  ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.primary, size: 35.sp),
              )
                  : CustomButton(
                  text: 'Confirm',
                  onPressed: () {
                    // Call the OTP verification method
                    otpController.verifyOtp(userId, otpController.otpController.text);
                  })),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Lifecycle Observer
class AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResume;

  AppLifecycleObserver(this.onResume);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      onResume(); // Check OTP when the app is resumed
    }
  }
}
