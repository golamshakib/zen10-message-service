import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/book_service/controllers/book_service_controller.dart';

class BookServiceView extends StatelessWidget {
  const BookServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller if it isn't already in memory
    final BookServiceController controller = Get.put(BookServiceController());

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 72.h,
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                      color: Color(0xffF0F0F0),
                      borderRadius: BorderRadius.circular(22.h)),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 20.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  'Book a service',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                )
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
            Text(
              'Choose Your Service',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            SizedBox(height: 8.h),
            Text(
              'Select the care you need today.',
              style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Obx(
                  () => categoryButton(
                    text: 'Massage',
                    isSelected: controller.selectedCategory.value == 'Massage',
                    onTap: () => controller.changeCategory('Massage'),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => categoryButton(
                    text: 'Stretch',
                    isSelected: controller.selectedCategory.value == 'Stretch',
                    onTap: () => controller.changeCategory('Stretch'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Services shown conditionally
            Expanded(
              child: Obx(
                () {
                  // Show the correct services based on selectedCategory
                  if (controller.selectedCategory.value == 'Massage') {
                    return Column(
                      children: [
                        serviceCard(
                          title: 'For Non-Members',
                          description: '30 minute massage',
                          price: '\$20.00',
                          isSelected: controller.selectedService.value ==
                              'Non-Members-Massage',
                          onTap: () =>
                              controller.changeService('Non-Members-Massage'),
                        ),
                        const SizedBox(height: 10),
                        serviceCard(
                          title: 'For Members',
                          description:
                              '10 minute massage, Footmassage, Prepaid for 4x',
                          price: '\$20.00',
                          isSelected: controller.selectedService.value ==
                              'Members-Massage',
                          onTap: () =>
                              controller.changeService('Members-Massage'),
                        ),
                      ],
                    );
                  } else {
                    // STRETCH services
                    return Column(
                      children: [
                        serviceCard(
                          title: 'For Non-Members',
                          description: '15 min assisted stretching',
                          price: '\$15.00',
                          isSelected: controller.selectedService.value ==
                              'Non-Members-Stretch',
                          onTap: () =>
                              controller.changeService('Non-Members-Stretch'),
                        ),
                        const SizedBox(height: 10),
                        serviceCard(
                          title: 'For Members',
                          description: '20 min deep stretch, Prepaid for 3x',
                          price: '\$18.00',
                          isSelected: controller.selectedService.value ==
                              'Members-Stretch',
                          onTap: () =>
                              controller.changeService('Members-Stretch'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            nextButton(),
          ],
        ),
      ),
    );
  }

  /// Category button widget
  Widget categoryButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(38.h),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.purple : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Service card widget
  Widget serviceCard({
    required String title,
    required String description,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade500 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.purple.shade500 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Price: $price',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Next button
  Widget nextButton() {
    return GestureDetector(
      onTap: () {
        // Handle next action
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15, bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.purple.shade500,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'Next',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
