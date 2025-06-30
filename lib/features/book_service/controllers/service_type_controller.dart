// import 'dart:developer';
//
// import 'package:get/get.dart';
// import 'package:traveling/core/services/Auth_service.dart';
// import 'package:traveling/core/services/network_caller.dart';
// import 'package:traveling/core/utils/constants/app_urls.dart';
// import 'package:traveling/core/utils/logging/logger.dart';
// import 'package:traveling/features/book_service/data/models/service_data_mode.dart';
// import '../data/models/servive_type_model.dart';
// import '../presentation/screens/book_service_screen.dart'; // Adjust if needed
//
// class ServiceTypeController extends GetxController {
//   // List of services fetched from the API
//   var services = <ServiceTypeModel>[].obs;
//
//   // Selected service category
//   var selectedCategory = ''.obs;
//
//   // Loading state
//   var isLoading = false.obs;
//
//   // Fetch services from the API using userID and selectedCategory
//   Future<void> fetchServices({
//     required String userID,
//   }) async {
//     try {
//       isLoading.value = true;
//
//       // Constructing the URL dynamically with userID and selectedCategory
//       final String url = AppUrls.getUserService(
//         userID: userID,
//         filter: selectedCategory.value,
//       );
//
//       // Make the network call
//       final response = await NetworkCaller().getRequest(
//         url,
//         token: "Bearer ${AuthService.token}",
//       );
//
//       isLoading.value = false;
//
//       if (response.isSuccess) {
//         final data = response.responseData; // No need to decode, it's already a Map<String, dynamic>
//
//         if (data['success'] == true) {
//           // Parse and store the services in the services list
//           services.value = List<ServiceTypeModel>.from(
//             data['data'].map((service) => ServiceTypeModel.fromJson(service)),
//           );
//         } else {
//           throw Exception('Failed to load services');
//         }
//       } else {
//         throw Exception('Failed to load services: ${response.errorMessage}');
//       }
//     } catch (error) {
//       isLoading.value = false;
//       print('Error fetching services: $error');
//     }
//   }
//
//   // Method to change selected category
//   void changeCategory(String serviceType) {
//     selectedCategory.value = serviceType;
//   }
//
//   // Method to navigate to the next screen with the selected category
//   void navigateToNextScreen() {
//     // Pass the selected category to the next screen
//     Get.to(() => BookServiceView(), arguments: {'selectedCategory': selectedCategory.value});
//   }
// }
