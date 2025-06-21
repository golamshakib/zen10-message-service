import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/common/widgets/custom_app_bar.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/book_service/controllers/book_service_controller.dart';
import 'package:traveling/features/book_service/presentation/screens/book_service_screen.dart';

class SelectServiceView extends StatelessWidget {
  // Add locationId parameter
  final dynamic userID;

  // Make it required in the constructor
  const SelectServiceView({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    final BookServiceController controller = Get.put(BookServiceController());

    // Log the locationId when the screen is built
    log('SelectServiceView opened with user ID: $userID');

    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(top: 72.h, left: 16.w, right: 16.w, bottom: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              onTap: () {
                Get.back();
              },
              text: 'Select a service',
            ),
            SizedBox(height: 40.h),
            Text(
              'Choose Your Service Type',
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                serviceContainer('Massage', Icons.spa, controller),
                serviceContainer('Stretch', Icons.fitness_center, controller),
              ],
            ),
            SizedBox(height: 40.h),
            Spacer(),
            CustomButton(
              onPressed: () {
                // Pass the locationId to the next screen if needed
                Get.to(() => BookServiceView(),
                    arguments: {'userID': userID});
              },
              text: 'Next',
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceContainer(
      String serviceType, IconData icon, BookServiceController controller) {
    return GestureDetector(
      onTap: () => controller.changeCategory(serviceType),
      child: Obx(
        () => Container(
          height: 140.h,
          width: 160.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: controller.selectedCategory.value == serviceType
                ? AppColors.primary
                : Colors.white,
            borderRadius: BorderRadius.circular(16.h),
            border: Border.all(
              color: controller.selectedCategory.value == serviceType
                  ? AppColors.primary
                  : Color(0xffE9E9F3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.sp,
                color: controller.selectedCategory.value == serviceType
                    ? Colors.white
                    : AppColors.primary,
              ),
              SizedBox(height: 8.h),
              Text(
                serviceType,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: controller.selectedCategory.value == serviceType
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
