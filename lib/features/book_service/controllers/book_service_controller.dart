import 'package:get/get.dart';

class BookServiceController extends GetxController {
  /// The currently selected category
  RxString selectedCategory = 'Massage'.obs;

  /// The currently selected service (depends on category)
  RxString selectedService = ''.obs;

  // Add these properties to store service details
  RxString serviceTitle = ''.obs;
  RxString serviceDescription = ''.obs;
  RxString servicePrice = ''.obs;

  /// Change the selected category
  void changeCategory(String category) {
    selectedCategory.value = category;
    // Reset selected service when category changes
    selectedService.value = '';
    // Reset service details
    serviceTitle.value = '';
    serviceDescription.value = '';
    servicePrice.value = '';
  }

  /// Change the selected service
  void changeService(String service) {
    selectedService.value = service;
  }

  /// Set service details
  void setServiceDetails(String title, String description, String price) {
    serviceTitle.value = title;
    serviceDescription.value = description;
    servicePrice.value = price;
  }

  /// Get formatted service title for summary
  String getFormattedServiceTitle() {
    if (selectedService.isEmpty) return '';

    if (selectedService.contains('Non-Members')) {
      return "$selectedCategory Service - Non Member";
    } else {
      return "$selectedCategory Service - Member";
    }
  }
}
