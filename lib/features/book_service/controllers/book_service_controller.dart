import 'package:get/get.dart';

class BookServiceController extends GetxController {
  /// The currently selected category
  RxString selectedCategory = 'Massage'.obs;

  /// The currently selected service (depends on category)
  RxString selectedService = 'Non-Members'.obs;

  /// Change the selected category
  void changeCategory(String category) {
    selectedCategory.value = category;
    // Reset selected service when category changes
    selectedService.value = '';
  }

  /// Change the selected service
  void changeService(String service) {
    selectedService.value = service;
  }
}
