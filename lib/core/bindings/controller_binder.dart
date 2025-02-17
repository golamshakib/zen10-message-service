

import 'package:get/get.dart';

import '../../features/splash_screen/controllers/splash_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LogInController>(
    //       () => LogInController(),
    //   fenix: true,
    // );

    Get.lazyPut<SplashController>(
          () => SplashController(),
      fenix: true,
    );
  }
}