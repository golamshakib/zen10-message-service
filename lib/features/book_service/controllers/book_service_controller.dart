import 'dart:developer';

import 'package:get/get.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/core/utils/logging/logger.dart';
import 'package:traveling/features/book_service/data/models/service_data_mode.dart';

class BookServiceController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<ServiceDataModel?> serviceData = Rx(null);
  Rx<ConnectedService?> selectedServiceCard = Rx(null);

  /// The currently selected category
  RxString selectedCategory = 'Message'.obs;

  /// The currently selected service (depends on category)
  RxInt selectedService = (-1).obs;

  // Add these properties to store service details
  RxString serviceTitle = ''.obs;
  RxString serviceDescription = ''.obs;
  RxString servicePrice = ''.obs;

  /// Change the selected category
  void changeCategory(
    String category,
  ) {
    selectedCategory.value = category;
    // Reset selected service when category changes
    selectedService.value = -1;
    // Reset service details
    serviceTitle.value = '';
    serviceDescription.value = '';
    servicePrice.value = '';
  }

  /// Change the selected service
  void changeService(int serviceIndex, ConnectedService cselectedService) {
    selectedService.value = serviceIndex;
    selectedServiceCard.value = cselectedService;
  }

  /// Set service details
  void setServiceDetails(String title, String description, String price) {
    serviceTitle.value = title;
    serviceDescription.value = description;
    servicePrice.value = price;
  }

  /// Get formatted service title for summary
  // String getFormattedServiceTitle() {
  //   if (selectedService.isEmpty) return '';

  //   if (selectedService.contains('Non-Members')) {
  //     return "$selectedCategory Service - Non Member";
  //   } else {
  //     return "$selectedCategory Service - Member";
  //   }
  // }

  Future<void> getServiceList({
    required String userID,
  }) async {
    log("Selected category: ${selectedCategory.value}");
    try {
      isLoading.value = true;
      final response = await NetworkCaller().getRequest(
          AppUrls.getUserService(
              userID: userID, filter: selectedCategory.value),
          token: "Bearer ${AuthService.token}");
      isLoading.value = false;
      if (response.isSuccess) {
        serviceData.value = ServiceDataModel.fromJson(response.responseData);
      } else {
        Get.snackbar("Error", response.errorMessage);
      }
    } catch (error) {
      isLoading.value = false;
      AppLoggerHelper.error(error.toString());
    }
  }
}
