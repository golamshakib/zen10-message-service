import 'dart:developer';

import 'package:get/get.dart';
import 'package:traveling/features/Payment/controllers/pay_and_book_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebViewController extends GetxController {
  final PayAndBookController controller = Get.put(PayAndBookController());
  late WebViewController webViewController;
  var loadingPercentage = 0.obs;
  RxString webUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => loadingPercentage.value = 0,
        onProgress: (progress) => loadingPercentage.value = progress,
        onPageFinished: (url) {
          loadingPercentage.value = 100;
          log("url is $url");
        },
        onNavigationRequest: (request) async {
          if (request.url.contains("http://10.0.20.36:8013/success")) {
            Get.back();

            await controller.capturePayment(orderId: controller.orderId.value);
            return NavigationDecision.prevent;
          } else if (request.url.contains("http://10.0.20.36:8013/cancel")) {
            Get.back();
            Get.snackbar("Error", "Somethng went wrong, please try again");
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ));

    ever<String>(webUrl, (url) {
      if (url.isNotEmpty) {
        webViewController.loadRequest(Uri.parse(url));
      }
    });
  }
}
