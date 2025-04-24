import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/authentication/controllers/forgot_password_controller.dart';

void showForgotPasswordDialog(BuildContext context) {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        content: SizedBox(
          width: 320.w,
          height: 300.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Please enter your email address below to receive OTP',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 45.h,
                width: double.infinity,
                child: TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    controller.errorMessage.value = '';
                  },
                  style: TextStyle(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                    hintText: 'Enter your email address',
                    hintStyle: TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.h),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.h),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.h),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                    () => controller.errorMessage.isNotEmpty
                    ? Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.red,
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Obx(
                      () => controller.isLoading.value
                      ? LoadingAnimationWidget.staggeredDotsWave(
                      color: AppColors.primary, size: 25.sp)
                      : CustomButton(
                    text: 'Send',
                    onPressed: controller.forgotPassword,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
