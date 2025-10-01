import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/features/notification/controller/notification_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:traveling/features/notification/presentation/components/custom_notification_card.dart';

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
            Get.offAllNamed(AppRoute.homeScreen); // Navigate to home screen
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            // Use animated dotted indicator while loading
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.primary,
                size: 50.0, // Adjust size as needed
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
                    child: Dismissible(
                      key: Key(notification.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // Call the delete method from the controller
                        controller.deleteNotification(notification.id);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: CustomNotificationCard(
                        bookingID: notification.bookingId,
                        title: notification.title,
                        body: notification.body,
                        createdAT: notification.createdAt,
                        username: notification.sender.userName,
                      ),
                    ),
                  );
                });
          }
        }),
      ),
    );
  }
}
