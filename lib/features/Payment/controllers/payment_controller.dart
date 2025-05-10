import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:traveling/core/services/Auth_service.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var selectedPaymentMethod = 'PayPal'.obs;
  var paypalEmail = ''.obs;
  var hasLinkedPayPal = false.obs;

  // Service IDs to book
  RxList<String> serviceIds = <String>[].obs;

  // Payment amount
  var amount = 0.0.obs;

  // PayPal order ID
  var paypalOrderId = ''.obs;
  var bookingId = ''.obs;

  // Set payment method
  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Set PayPal email
  void setPayPalEmail(String email) {
    paypalEmail.value = email;
    hasLinkedPayPal.value = true;
  }

  // Link PayPal account
  Future<bool> linkPayPalAccount(String email) async {
    isLoading.value = true;
    try {
      // In a real app, you would call your API to link the PayPal account
      // For now, we'll just simulate success
      await Future.delayed(Duration(seconds: 1));
      paypalEmail.value = email;
      hasLinkedPayPal.value = true;
      return true;
    } catch (e) {
      print('Error linking PayPal account: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Create booking
  Future<Map<String, dynamic>> createBooking() async {
    try {
      final token = AuthService.token;
      if (token == null) {
        throw Exception('Authentication token is not available');
      }

      final ownerId = AuthService.userId; // Assuming you have userId in AuthService
      if (ownerId == null) {
        throw Exception('User ID is not available');
      }

      final response = await http.post(
        Uri.parse('${AppUrls.baseUrl}/bookings/create-booking/$ownerId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'connectedServiceIds': serviceIds,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Booking created successfully');
        bookingId.value = responseData['data']['id'];
        return responseData['data'];
      } else {
        print('Failed to create booking: ${responseData['message']}');
        throw Exception('Failed to create booking: ${responseData['message']}');
      }
    } catch (e) {
      print('Error creating booking: $e');
      throw Exception('Error creating booking: $e');
    }
  }

  // Create PayPal payment
  Future<Map<String, dynamic>> createPayPalPayment() async {
    try {
      final token = AuthService.token;
      if (token == null) {
        throw Exception('Authentication token is not available');
      }

      final response = await http.post(
        Uri.parse('${AppUrls.baseUrl}/payments/create-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount.value,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Payment created successfully');
        paypalOrderId.value = responseData['data']['orderId'];
        return responseData['data'];
      } else {
        print('Failed to create payment: ${responseData['message']}');
        throw Exception('Failed to create payment: ${responseData['message']}');
      }
    } catch (e) {
      print('Error creating payment: $e');
      throw Exception('Error creating payment: $e');
    }
  }

  // Capture PayPal payment
  Future<bool> capturePayPalPayment() async {
    try {
      final token = AuthService.token;
      if (token == null) {
        throw Exception('Authentication token is not available');
      }

      final response = await http.post(
        Uri.parse('${AppUrls.baseUrl}/payments/capture-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'orderId': paypalOrderId.value,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Payment captured successfully');
        return true;
      } else {
        print('Failed to capture payment: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      print('Error capturing payment: $e');
      return false;
    }
  }

  // Process payment and booking
  Future<bool> processPaymentAndBooking() async {
    isLoading.value = true;
    try {
      // 1. Create booking first
      await createBooking();

      // 2. Create PayPal payment
      final paymentData = await createPayPalPayment();
      final approvalUrl = paymentData['approvalUrl'];

      // 3. Launch PayPal approval URL
      if (await canLaunch(approvalUrl)) {
        await launch(approvalUrl);
        return true;
      } else {
        throw Exception('Could not launch PayPal approval URL');
      }
    } catch (e) {
      print('Error processing payment and booking: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Set service IDs and amount
  void setServiceDetails(List<String> ids, double totalAmount) {
    serviceIds.value = ids;
    amount.value = totalAmount;
  }
}

