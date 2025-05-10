import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/core/utils/logging/logger.dart';
import 'package:traveling/features/notification/data/model/notification_data_mode.dart';

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
}
