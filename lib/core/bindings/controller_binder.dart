import 'package:get/get.dart';
import 'package:traveling/features/authentication/controllers/location_controller.dart';
import 'package:traveling/features/authentication/controllers/login_controller.dart';
import 'package:traveling/features/authentication/controllers/otp_verification_controller.dart';
import 'package:traveling/features/authentication/controllers/sing_up_controller.dart';
import 'package:traveling/features/home/controllers/home_controller.dart';

import '../../features/splash_screen/controllers/splash_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(
          () => LocationController(),
      fenix: true,
    );

    Get.lazyPut<LoginController>(
      () => LoginController(),
      fenix: true,
    );

    Get.lazyPut<SplashController>(
      () => SplashController(),
      fenix: true,
    );

    Get.lazyPut<SingUpController>(
      () => SingUpController(),
      fenix: true,
    );

    Get.lazyPut<OtpVerificationController>(
      () => OtpVerificationController(),
      fenix: true,
    );
    Get.lazyPut<HomeScreenController>(
          () => HomeScreenController(),
      fenix: true,
    );
  }
}
