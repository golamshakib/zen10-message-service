import 'dart:developer';

import 'package:get/get.dart';
import 'package:traveling/core/services/Auth_service.dart';
import 'package:traveling/core/services/network_caller.dart';
import 'package:traveling/core/utils/constants/app_urls.dart';
import 'package:traveling/core/utils/logging/logger.dart';
import 'package:traveling/features/Payment/presentation/screens/pay_pal_web_view.dart';
import 'package:traveling/features/home/presentation/screens/home_screen.dart';

class PayAndBookController extends GetxController {
  RxBool isPaymentLoading = false.obs;

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
      final Map<String, dynamic> requestbody = {
        "amount": amount,
        "bookingId": bookingId,
      };

      final request = await NetworkCaller().postRequest(AppUrls.createPayment,
          body: requestbody, token: "Bearer ${AuthService.token}");
      log(request.responseData.toString());
      if (request.isSuccess) {
        // Save the order id,
        final String? orderID = request.responseData["data"]["orderId"];
        final String? payPalUrl = request.responseData["data"]["approvalUrl"];

        if (orderID != null && payPalUrl != null) {
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
      final response = await NetworkCaller()
          .postRequest(AppUrls.capturePayment(orderId: orderId));
      isPaymentLoading.value = false;
      if (response.isSuccess) {
        // show payment succes message

        Get.offAll(() => HomeScreen());
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
