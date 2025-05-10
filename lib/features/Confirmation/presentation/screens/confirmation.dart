import 'package:flutter/material.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/core/utils/constants/image_path.dart';

class BookingConfirmed extends StatelessWidget {
  const BookingConfirmed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 128.h, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.confirm, width: 145.w, height: 145.h),
            SizedBox(height: 24.h),
            Text(
              "Booking Confirmed!",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Thank you! Your session is scheduled and we’ll notify you 5 minutes before it starts.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffE9E9F3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your session is expected to start in:",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "45 Minute",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Color(0xffD7D7D7),
                    color: AppColors.primary,
                    minHeight: 3,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            CustomButton(
                onPressed: () {
                  // Get.to(() => ThankYouPage());
                },
                text: "Back to Home")
          ],
        ),
      ),
    );
  }
}
