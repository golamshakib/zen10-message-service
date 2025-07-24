import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/routes/app_routes.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/image_path.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 128.h, bottom: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagePath.thank, width: 145.w, height: 145.h),
                SizedBox(height: 24.h),
                // Text(
                //   "Receipt",
                //   style: TextStyle(
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.w700,
                //     color: AppColors.primary,
                //   ),
                // ),
                SizedBox(height: 8.h),
                Text(
                  "Thank you for your purchase.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 40.h),
                Text(
                  "Contact Information",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                // Customer Details
                Row(
                  children: [
                    Text(
                      "Email: ",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "customer@example.com", // Replace with dynamic email
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text(
                      "Contact: ",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "+1234567890", // Replace with dynamic contact
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text(
                      "Website: ",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "www.example.com", // Replace with dynamic website
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Service Time
                Row(
                  children: [
                    Text(
                      "Service Time: ",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "1:00 PM, July 15, 2025", // Replace with dynamic time
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                // Back button
                CustomButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoute.homeScreen); // Navigate to home screen
                  },
                  text: 'Back',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
