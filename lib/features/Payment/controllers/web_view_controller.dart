import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebViewController extends GetxController {
  late WebViewController webViewController;
  var loadingPercentage = 0.obs;
  RxString webUrl = "".obs;
  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => loadingPercentage.value = 0,
        onProgress: (progress) => loadingPercentage.value = progress,
        onPageFinished: (url) => loadingPercentage.value = 100,
      ))
      ..loadRequest(
        Uri.parse(webUrl.value),
      );
  }
}
