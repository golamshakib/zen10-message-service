import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/features/Payment/controllers/web_view_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalWebView extends StatelessWidget {
  PayPalWebView(
      {super.key,
      required this.approvalUrl,
        required this.userID,
      required this.eventStartDate,
      required this.eventEndDate,
      required this.eventStartTime,
      required this.eventEndTime,
      }) {
    controller.webUrl.value = approvalUrl;
  }

  final String approvalUrl;
    final String userID;
  final String eventStartDate;
  final String eventEndDate;
  final String eventStartTime;
  final String eventEndTime;



  final CustomWebViewController controller = Get.put(CustomWebViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Pay with PayPal"),
      ),
      body: SafeArea(
        child: Obx(() => Stack(
              children: [
                WebViewWidget(
                  controller: controller.webViewController,
                ),
                controller.loadingPercentage.value < 100
                    ? LinearProgressIndicator(
                        value: controller.loadingPercentage.value.toDouble(),
                        color:
                            animatedColors(controller.loadingPercentage.value),
                      )
                    : Container(),
              ],
            )),
      ),
    );
  }
}

ColorSwatch<int> animatedColors(int value) {
  switch (value) {
    case 20:
      return Colors.amber;
    case 40:
      return Colors.pink;
    case 60:
      return Colors.pinkAccent;
    case 80:
      return Colors.greenAccent;
    case 100:
      return Colors.green;

    default:
      return Colors.green;
  }
}
