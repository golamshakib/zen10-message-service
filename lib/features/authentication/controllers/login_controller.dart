import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling/core/utils/constants/app_colors.dart';

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
  var obscureText = true.obs;
  RxBool isLoading = false.obs;
  // Remember Me Checkbox state
  var isRememberMeChecked = false.obs;

  void toggleRememberMe() {
    isRememberMeChecked.value = !isRememberMeChecked.value;
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }



  @override
  void onInit() {
    initializeFCM();
    saveRememberMeCredentials();
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
      log('Error: ${response.responseData}');
      if (response.isSuccess) {
        String? token = response.responseData['data']['accessToken'];


        if (token != null) {
          await AuthService.saveToken(token);

          if (isRememberMeChecked.value) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('rememberMe', true);
            await prefs.setString('email', email);
            await prefs.setString('password', password);
          } else {
            // Clear the saved credentials if "Remember Me" is not checked
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('rememberMe');
            await prefs.remove('email');
            await prefs.remove('password');
          }

          showSnackBar(
            title: 'Success',
            message: 'Logged in successfully',
            icon: Icons.check_circle_outline,
            color: AppColors.primary,
          );
          log("Saved token is: ${AuthService.token}");
          Get.offAll(() => HomeScreen());
        }
      } else {
        if (response.statusCode == 400) {
          String errorMessage = response.responseData['message']  ?? 'Invalid Email or Password';
          showSnackBar(
            title: 'Error',
            message: errorMessage,
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

  static Future<void> saveRememberMeCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? rememberMe = prefs.getBool('rememberMe');

    if (rememberMe == true) {

      // Auto fill the email and password fields if "Remember Me" is enabled
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');
      if (email != null && password != null) {
        final LoginController loginController = Get.find<LoginController>();
        loginController.emailController.text = email;
        loginController.passwordController.text = password;
        loginController.isRememberMeChecked.value = true;
      }
    } else {
      // If "Remember Me" is not enabled, ensure the fields are empty
      final LoginController loginController = Get.find<LoginController>();
      loginController.emailController.clear();
      loginController.passwordController.clear();
      loginController.isRememberMeChecked.value = false;
    }
  }
}
