import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/core/utils/logging/logger.dart';
import 'package:traveling/features/Payment/presentation/screens/pay_pal_web_view.dart';
import 'package:traveling/features/Payment/presentation/screens/receipt_screen.dart';
import 'package:http/http.dart' as http;

import '../../authentication/presentation/widgets/showSnacker.dart';

class PayAndBookController extends GetxController {
  RxBool isPaymentLoading = false.obs;
  RxString orderId = "".obs;
  RxString userID = "".obs;
  RxString eventStartDate = "".obs;
  RxString eventEndDate = "".obs;
  RxString eventStartTime = "".obs;
  RxString eventEndTime = "".obs;

  void setEventData(
      String userId, String startDate, String endDate, String startTime, String endTime) {
    userID.value = userId;
    eventStartDate.value = startDate;
    eventEndDate.value = endDate;
    eventStartTime.value = startTime;
    eventEndTime.value = endTime;
  }

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

        setEventData(
          Get.arguments['userID'].toString(),
          Get.arguments['eventStartDate'].toString(),
          Get.arguments['eventEndDate'].toString(),
          Get.arguments['eventStartTime'].toString(),
          Get.arguments['eventEndTime'].toString(),
        );
        // Proceed with paypal web view
        createPayment(amount: amount, bookingId: bookingId ?? "");
      } else {
        // Show snakbar
        showSnackBar(
          title: 'Error',
          message: 'Failed to create booking. Please try again.',
          icon: Icons.error,
          color: Colors.red,
        );
        isPaymentLoading.value = false;
      }
    } catch (error) {
      AppLoggerHelper.error(error.toString());
      isPaymentLoading.value = false;
      showSnackBar(
        title: 'Error',
        message: 'An error occurred. Please try again later.',
        icon: Icons.error,
        color: Colors.red,
      );
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
        final String? orderID = request.responseData["data"]?["orderId"];
        final String? payPalUrl = request.responseData["data"]?["approvalUrl"];

        if (orderID != null && payPalUrl != null) {
          isPaymentLoading.value = false;
          log("OrderID : $orderID");
          orderId.value = orderID;
          Get.to(
            () => PayPalWebView(
              approvalUrl: payPalUrl,
              userID: userID.value,
              eventStartDate: eventStartDate.value,
              eventEndDate: eventEndDate.value,
              eventStartTime: eventStartTime.value,
              eventEndTime: eventEndTime.value,
            ),
          );
        }
      } else {
        isPaymentLoading.value = false;
        // Capture error status code and message
        log("Error Status Code: ${request.statusCode}");
        log("Error Message: ${request.responseData["message"]}");
        log("Error Details: ${request.responseData["errorMessages"]}");

        // Error snakbar
        showSnackBar(
          title: 'Error',
          message: 'Failed to retrieve PayPal payment details. Please try again.',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    } catch (error) {
      AppLoggerHelper.error(error.toString());
      isPaymentLoading.value = false;
      showSnackBar(
        title: 'Error',
        message: 'An error occurred during the payment process. Please try again.',
        icon: Icons.error,
        color: Colors.red,
      );
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
        // show payment success message
        Get.to(
          () => ReceiptScreen(
            userID: userID.value,
            eventStartDate: eventStartDate.value,
            eventEndDate: eventEndDate.value,
            eventStartTime: eventStartTime.value,
            eventEndTime: eventEndTime.value,
          ),
        );
        // Get.toNamed(AppRoute.receiptScreen);
        log("Payment successfull");
        showSnackBar(
          title: 'Success',
          message: 'Payment successful! Thank you for your purchase.',
          icon: Icons.check_circle_outline,
          color: AppColors.primary,
        );

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
