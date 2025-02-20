import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/core/utils/constants/logo_path.dart';

import '../../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
final splashController = Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
             LogoPath.appLogo, // Replace with your logo asset path
              width: 150, // Set your desired width
              height: 150, // Set your desired height
            ),
            const SizedBox(height: 20), // Add some spacing between the logo and text
            const Text(
              'My Awesome App',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}