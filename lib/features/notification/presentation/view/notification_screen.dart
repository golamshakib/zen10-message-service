import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_sizer.dart';
import 'package:traveling/features/notification/controller/notification_controller.dart';
import 'package:traveling/features/notification/presentation/components/custom_notification_card.dart';

import '../../../../core/services/notification_services.dart';
import '../../../../routes/app_routes.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final NotificationController controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the home screen when back button is pressed
            Get.offAllNamed(AppRoute.homeScreen); // Replace with your home screen route
          },
        ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            } else if (controller.notifications.value == null) {
              return Center(
                child: Text(
                  "Something went wrong, please check your internet and try again",
                  textAlign: TextAlign.center,
                ),
              );
            } else if (controller.notifications.value!.data.data.isEmpty) {
              return Center(
                child: Text("No Notifications are available"),
              );
            } else {
              final notifications = controller.notifications.value!.data.data;
              return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomNotificationCard(
                        bookingID: notification.bookingId,
                        title: notification.title,
                        body: notification.body,
                        createdAT: notification.createdAt,
                        username: notification.sender.userName,
                      ),
                    );
                  });
            }
          })),
    );
  }
}
