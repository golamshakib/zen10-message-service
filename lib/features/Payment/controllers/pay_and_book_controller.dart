import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/core/utils/logging/logger.dart';
import 'package:traveling/features/Payment/presentation/screens/pay_pal_web_view.dart';
import 'package:traveling/features/home/presentation/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class PayAndBookController extends GetxController {
  RxBool isPaymentLoading = false.obs;
  RxString orderId = "".obs;

  Future<void> crateBooking({
    required String connectedServiceId,
    required String ownerId,
    required int amount,
  }) async {
    try {
      //Payment started
      isPaymentLoading.value = true;

      final Map<String, dynamic> requestBdy = {
        "connectedServiceIds": connectedServiceId
      };

      final response = await NetworkCaller().postRequest(
          AppUrls.createBooking(ownerId: ownerId),
          body: requestBdy,
          token: "Bearer ${AuthService.token}");
      isPaymentLoading.value = false;
      log(response.responseData.toString());
      if (response.isSuccess) {
        final String? bookingId = response.responseData["data"]["id"];
        // Proceed with paypal web view
        createPayment(amount: amount, bookingId: bookingId ?? "");
      } else {
        // Show snakbar
        isPaymentLoading.value = false;
      }
    } catch (error) {
      AppLoggerHelper.error(error.toString());
      isPaymentLoading.value = false;
    }
  }

  Future<void> createPayment(
      {required int amount, required String bookingId}) async {
    try {
      isPaymentLoading.value = true;
      final Map<String, dynamic> requestbody = {
        "amount": amount,
        "bookingId": bookingId,
      };

      final request = await NetworkCaller().postRequest(AppUrls.createPayment,
          body: requestbody, token: "Bearer ${AuthService.token}");
      log(request.responseData.toString());
      isPaymentLoading.value = false;
      if (request.isSuccess) {
        // Save the order id,
        final String? orderID = request.responseData["data"]["orderId"];
        final String? payPalUrl = request.responseData["data"]["approvalUrl"];

        if (orderID != null && payPalUrl != null) {
          isPaymentLoading.value = false;
          log("OrderID : $orderID");
          orderId.value = orderID;
          Get.to(() => PayPalWebView(
                approvalUrl: payPalUrl,
              ));
        }
      } else {
        isPaymentLoading.value = false;
        // Error snakbar
      }
    } catch (error) {
      AppLoggerHelper.error(error.toString());
      isPaymentLoading.value = false;
    }
  }

  Future<void> capturePayment({required String orderId}) async {
    try {
      isPaymentLoading.value = true;
      log("Token is: ${AuthService.token}");
      final response = await http.post(
          Uri.parse(AppUrls.capturePayment(orderId: orderId)),
          headers: {"Authorization": "Bearer ${AuthService.token}"});
      isPaymentLoading.value = false;
      log("Capture payment: ${response.body}");
      if (response.statusCode == 200) {
        // show payment succes message

        Get.offAll(() => HomeScreen());
        log("Payment successfull");
        Get.snackbar(
            "Success", "Payment successful! Thank you for your purchase.",
            backgroundColor: AppColors.success, colorText: Colors.white);
        // Payment successfull
      } else {
        isPaymentLoading.value = false;
        //error snakbar
      }
    } catch (error) {
      isPaymentLoading.value = false;
      AppLoggerHelper.error(error.toString());
    } finally {
      isPaymentLoading.value = false;
    }
  }
}
