import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/authentication/controllers/otp_verification_controller.dart';

import '../../../../core/utils/constants/logo_path.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key, required this.email, required this.userId});

  final String email;
  final String userId;
  final otpController = Get.find<OtpVerificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70.h),
              Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    LogoPath.appLogo,
                    height: 80.h,
                    width: 80.w,
                  )),
              SizedBox(
                height: 16.h,
              ),
              Text(
                'OTP Verification',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                'Please enter the verification code that has been sent to your email.',
                style: TextStyle(),
              ),
              SizedBox(height: 15.h),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {},
                controller: otpController.otpController,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5.h),
                  fieldHeight: 50.h,
                  fieldWidth: 40.w,
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
              SizedBox(height: 15.h),
              Obx(() => Center(
                child: Text(
                  otpController.start.value == 0
                      ? 'Didn’t receive the OTP?'
                      : 'Resend OTP in ${otpController.start.value} seconds',
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                ),
              )),
              SizedBox(height: 10.h),
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
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              CustomButton(
                  text: 'Confirm',
                  onPressed: () {
                    // Call the OTP verification method
                    otpController.verifyOtp(userId, otpController.otpController.text);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
