import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/core/utils/logging/logger.dart';
import 'package:traveling/features/notification/data/model/notification_data_mode.dart';

import '../../authentication/presentation/widgets/showSnacker.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<NotificationDataModel?> notifications = Rx(null);
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMyNotification();
  }

  Future<void> getMyNotification() async {
    try {
      isLoading.value = true;
      final response = await NetworkCaller().getRequest(
          AppUrls.getMyNotifications,
          token: "Bearer ${AuthService.token}");
      isLoading.value = false;
      if (response.isSuccess) {
        notifications.value =
            NotificationDataModel.fromJson(response.responseData);
      } else {
        Get.snackbar("Error", response.errorMessage,
            backgroundColor: AppColors.error, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      AppLoggerHelper.error(e.toString());
    }
  }

  // Delete notification method
  Future<void> deleteNotification(String notificationId) async {
    try {
      // Update UI immediately by removing the notification from the list
      notifications.value!.data.data.removeWhere((item) => item.id == notificationId);
      update(); // Update the UI immediately

      // Show a success snackbar immediately
      // Get.snackbar(
      //   "Success",
      //   "Notification deleted successfully",
      //   backgroundColor: AppColors.success,
      //   colorText: Colors.white,
      // );

      // Now proceed with the network request to delete the notification on the backend
      isLoading.value = true;

      final response = await NetworkCaller().deleteRequest(
        AppUrls.deleteNotifications(notificationId: notificationId),
        "Bearer ${AuthService.token}",
      );

      isLoading.value = false;

      if (!response.isSuccess) {
        // If the deletion failed, add the notification back to the list
        notifications.value!.data.data.addAll([response.responseData]);
        update(); // Update the UI to show the notification again

        // Show an error snackbar

        showSnackBar(
          title: 'Error',
          message: response.errorMessage,
          icon: Icons.error_outlined,
          color: Colors.redAccent,
        );
      }

      // Remove from local storage if deletion was successful
      if (response.isSuccess) {
        await _removeNotificationFromLocalStorage(notificationId);
      }

    } catch (e) {
      isLoading.value = false;
      AppLoggerHelper.error(e.toString());
    }
  }


  // Remove deleted notification from local storage
  Future<void> _removeNotificationFromLocalStorage(String notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing = prefs.getStringList('notifications') ?? [];
      final updated = existing.where((notification) {
        final notificationData = jsonDecode(notification);
        return notificationData['id'] != notificationId;
      }).toList();

      await prefs.setStringList('notifications', updated);
    } catch (e) {
      log("Error removing notification from local storage: $e");
    }
  }

}
