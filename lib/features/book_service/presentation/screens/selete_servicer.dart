import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';  // Import the loading animation widget
import 'package:traveling/core/common/widgets/custom_app_bar.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/book_service/controllers/book_service_controller.dart';
import 'package:traveling/features/book_service/presentation/screens/book_service_screen.dart';

class SelectServiceView extends StatelessWidget {
  final dynamic userID;

  const SelectServiceView({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    final BookServiceController controller = Get.put(BookServiceController());

    // Log the locationId when the screen is built
    log('SelectServiceView opened with user ID: $userID');

    // Fetch the service types when the screen is built
    controller.fetchServiceTypes();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 72.h, left: 16.w, right: 16.w, bottom: 25.h),
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
            // Use a Stack to layer the content and the loading animation
            Expanded(
              child: Stack(
                children: [
                  // The GridView displaying the services
                  Obx(() {
                    if (controller.isLoading.value) {
                      return SizedBox.shrink();  // Do not display the list when loading
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two items per row
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 2 / 1, // Adjust the aspect ratio as needed
                      ),
                      itemCount: controller.serviceTypes.length,
                      itemBuilder: (context, index) {
                        final serviceType = controller.serviceTypes[index];
                        return serviceContainer(serviceType, controller);
                      },
                    );
                  }),

                  // The loading animation centered on top of the GridView
                  Obx(() {
                    if (!controller.isLoading.value) {
                      return SizedBox.shrink();  // Hide loading animation when not loading
                    }
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.primary,
                        size: 30.sp, // Adjust the size of the loading animation
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Spacer to push the button to the bottom
            // Spacer(),
            CustomButton(
              onPressed: () {
                // Pass the locationId to the next screen if needed
                Get.to(() => BookServiceView(),
                    arguments: {'userID': userID});
              },
              text: 'Next',
            ),
            SizedBox(height: 50.h), // Add the 40 SizedBox below the button
          ],
        ),
      ),
    );
  }

  Widget serviceContainer(String serviceType, BookServiceController controller) {
    return GestureDetector(
      onTap: () => controller.changeCategory(serviceType),
      child: Obx(
            () => Container(
          height: 100.h,
          padding: EdgeInsets.all(12.h),
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
              Text(
                serviceType,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  overflow: TextOverflow.ellipsis,
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
