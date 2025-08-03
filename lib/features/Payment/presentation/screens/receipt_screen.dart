import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/routes/app_routes.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/image_path.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({
    super.key,
    required this.userID,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventStartTime,
    required this.eventEndTime,
  });

  final String userID;
  final String eventStartDate;
  final String eventEndDate;
  final String eventStartTime;
  final String eventEndTime;

  @override
  Widget build(BuildContext context) {
    log('User Id : $userID');
    log('Event Date : $eventStartDate');
    log('Event Date : $eventEndDate');
    log('Start Time: $eventStartTime');
    log('End Time : $eventEndTime');
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
                    eventEndDate.isEmpty
                    ? "Thank you for your Tips."
                    : "Thank you for using our service!",
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
                        "Zen10mobilemassage@outlook.com",
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
                      "Phone: ",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "(407) 602-4065",
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
                        "zen10mobilemassage.com",
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
                if (eventEndDate.isNotEmpty) ...[
                  // Service Date
                  Row(
                    children: [
                      Text(
                        "Service Date: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "$eventStartDate to $eventEndDate", // Replace with dynamic time
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
                ],
                SizedBox(height: 16.h),
                if (eventStartTime.isNotEmpty && eventEndTime.isNotEmpty) ...[
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
                          "$eventStartTime to $eventEndTime",
                          // Replace with dynamic time
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
                ],
                SizedBox(height: 40.h),

                // Back button
                CustomButton(
                  onPressed: () {
                    Get.offAllNamed(
                        AppRoute.homeScreen); // Navigate to home screen
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
