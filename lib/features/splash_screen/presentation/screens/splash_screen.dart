import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/utils/constants/logo_path.dart';
import '../../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final splashController = Get.put(SplashController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              LogoPath.appLogo,
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
