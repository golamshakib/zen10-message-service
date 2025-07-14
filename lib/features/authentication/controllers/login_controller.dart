import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../presentation/widgets/showSnacker.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var fcmToken = '';

  // Remember Me Checkbox state
  var isRememberMeChecked = false.obs;

  void toggleRememberMe() {
    isRememberMeChecked.value = !isRememberMeChecked.value;
  }

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    initializeFCM();
    // TODO: implement onInit
    super.onInit();

  }

  Future<void> initializeFCM() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      String? apnsToken;
      int attempts = 0;
      const int maxAttempts = 10;

      do {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        await Future.delayed(const Duration(milliseconds: 300));
        attempts++;
      } while (apnsToken == null && attempts < maxAttempts);

      log("APNS Token: $apnsToken");
    }

    String? token = await FirebaseMessaging.instance.getToken();

    fcmToken = token ?? "";
    log("FCM Token: $fcmToken");
  }
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    isLoading(true);
    final Map<String, String> requestBody = {
      'email': email,
      "password": password,
      "fcmToken": fcmToken,
    };

    try {
      final response =
          await NetworkCaller().postRequest(AppUrls.login, body: requestBody);

      if (response.isSuccess) {
        String? token = response.responseData['data']['accessToken'];

        if (token != null) {
          await AuthService.saveToken(token);
          showSnackBar(
            title: 'Success',
            message: 'Logged in successfully',
            icon: Icons.check_circle_outline,
            color: Colors.greenAccent,
          );
          log("Saved token is: ${AuthService.token}");
          Get.offAll(() => HomeScreen());
        }
      } else {
        if (response.statusCode == 400) {
          showSnackBar(
            title: 'Error',
            message: 'Please check your email and password.',
            icon: Icons.error_outline_rounded,
            color: Colors.redAccent,
          );
        } else {
          // Handle other errors from the API
          showSnackBar(
            title: 'Error',
            message: response.errorMessage ??
                'An error occurred. Please try again later.',
            icon: Icons.error_outline_rounded,
            color: Colors.redAccent,
          );
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
