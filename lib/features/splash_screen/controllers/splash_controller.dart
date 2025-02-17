import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  void navigateToHomeScreen() {
    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        Get.offAllNamed(
          AppRoute.loginScreen,
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    navigateToHomeScreen();
  }
}
