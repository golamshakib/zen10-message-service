import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/common/widgets/custom_app_bar.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/book_service/controllers/book_service_controller.dart';
import 'package:traveling/features/summery/presentation/screens/summery_screen.dart';

class BookServiceView extends StatelessWidget {
  const BookServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller if it isn't already in memory
    final BookServiceController controller = Get.put(BookServiceController());

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
              text: 'Book a service',
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
            SizedBox(height: 40.h),
            Expanded(
              child: Obx(
                    () {
                  if (controller.selectedCategory.value == 'Massage') {
                    return Column(
                      children: [
                        serviceCard(
                          title: 'For Non-Members',
                          description: '30 minute massage',
                          price: '\$20.00',
                          isSelected: controller.selectedService.value ==
                              'Non-Members-Massage',
                          onTap: () {
                            controller.changeService('Non-Members-Massage');
                            controller.setServiceDetails(
                                'For Non-Members',
                                '30 minute massage',
                                '\$20.00'
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        serviceCard(
                          title: 'For Members',
                          description:
                          '10 minute massage, Footmassage, Prepaid for 4x',
                          price: '\$20.00',
                          isSelected: controller.selectedService.value ==
                              'Members-Massage',
                          onTap: () {
                            controller.changeService('Members-Massage');
                            controller.setServiceDetails(
                                'For Members',
                                '10 minute massage, Footmassage, Prepaid for 4x',
                                '\$20.00'
                            );
                          },
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
                          onTap: () {
                            controller.changeService('Non-Members-Stretch');
                            controller.setServiceDetails(
                                'For Non-Members',
                                '15 min assisted stretching',
                                '\$15.00'
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        serviceCard(
                          title: 'For Members',
                          description: '20 min deep stretch, Prepaid for 3x',
                          price: '\$18.00',
                          isSelected: controller.selectedService.value ==
                              'Members-Stretch',
                          onTap: () {
                            controller.changeService('Members-Stretch');
                            controller.setServiceDetails(
                                'For Members',
                                '20 min deep stretch, Prepaid for 3x',
                                '\$18.00'
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            CustomButton(
                onPressed: () async {
                  if (controller.selectedService.isEmpty) {
                    // Show snackbar if no service is selected
                    Get.snackbar(
                      'Selection Required',
                      'Please select a service type',
                      backgroundColor: Colors.red[100],
                      colorText: Colors.red[800],
                      margin: EdgeInsets.all(16),
                      duration: Duration(seconds: 2),
                      borderRadius: 8,
                      icon: Icon(Icons.warning_amber_rounded, color: Colors.red[800]),
                    );
                  } else {
                    // Navigate to summary screen if service is selected
                    Get.to(() => SummaryScreen());
                  }
                },
                text: "Next"),
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
        padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 48.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(38.h),
          border: Border.all(
            color: isSelected ? AppColors.primary : Color(0xffE9E9F3),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Color(0xff808080),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 16.sp,
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
        width: double.maxFinite,
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(
            color: isSelected ? AppColors.primary : Color(0xffE9E9F3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Color(0xffD5D3FD) : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'Price: $price',
              style: TextStyle(
                color: isSelected ? Color(0xffD5D3FD) : Color(0xff808080),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
