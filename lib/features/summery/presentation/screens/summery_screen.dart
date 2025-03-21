import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/common/widgets/custom_app_bar.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/Payment/presentation/screens/payment_screen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 72, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              onTap: () {
                Get.back();
              },
              text: "Summary",
            ),
            SizedBox(
              height: 40.h,
            ),
            _buildServiceItem(
              title: "Massage Service - Non Member",
              subtitle: "30 minute massage",
              price: "\$20.00",
            ),
            // _buildServiceItem(
            //   title: "Stretch Service - Member",
            //   subtitle: "10 minute stretch, additional service",
            //   price: "\$10.00",
            // ),
            const Divider(
              color: Color(0xffE9E9F3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                  Text(
                    "\$20.00",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
                onPressed: () {
                  Get.to(() => PaymentMethodScreen());
                },
                text: "Next")
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem({
    required String title,
    required String subtitle,
    required String price,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 2,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFE9E9F3),
                width: 1.0,
              ),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          Text(
            price,
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
