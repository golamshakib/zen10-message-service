import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/common/widgets/custom_app_bar.dart';
import 'package:traveling/core/common/widgets/custom_button.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/book_service/controllers/book_service_controller.dart';
import 'package:traveling/features/summery/presentation/screens/summery_screen.dart';

import '../../data/models/service_data_mode.dart';

class BookServiceView extends StatelessWidget {
  final String userID = Get.arguments["userID"].toString();
  final BookServiceController controller = Get.put(BookServiceController());

  @override
  Widget build(BuildContext context) {
    log("Passed user id is: $userID");

    // Use Future.delayed to fetch data after the widget is built
    Future.delayed(Duration.zero, () {
      controller.getServiceList(userID: userID);
    });

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
              text: 'Book a service',
            ),
            SizedBox(height: 40.h),
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
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                // Check if the service data is null or empty
                if (controller.serviceData.value!.data[0].connectedService == null || controller.serviceData.value!.data[0].connectedService.isEmpty) {
                  return Center(
                    child: Text("No service available at this time"),
                  );
                }

                final services = controller.serviceData.value!.data[0].connectedService;
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Obx(() => serviceCard(
                          title: service.type,
                          description: service.offer,
                          duration: service.duration,
                          price: service.price.toString(),
                          isSelected: controller.selectedService.value == index,
                          onTap: () {
                            controller.changeService(index, service);
                          })),
                    );
                  },
                );
              }),
            ),
            CustomButton(
              onPressed: () async {
                if (controller.selectedService.value < 0) {
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
                  Get.to(() => SummaryScreen(
                    selectedService: controller.selectedServiceCard.value ??
                        ConnectedService(
                          id: '',
                          userId: userID,
                          serviceId: '',
                          type: '',
                          offer: '',
                          additionalOffer: '',
                          duration: '',
                          price: 0,
                          createdAt: "",
                          updatedAt: "",
                        ),
                  ));
                }
              },
              text: "Next",
            ),
          ],
        ),
      ),
    );
  }

  /// Service card widget
  Widget serviceCard({
    required String title,
    required String description,
    required String price,
    required String duration,
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
              duration,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Color(0xffD5D3FD) : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'Price: \$$price',
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
