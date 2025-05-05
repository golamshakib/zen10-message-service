import 'dart:developer';

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

  // Remember Me Checkbox state
  var isRememberMeChecked = false.obs;

  void toggleRememberMe() {
    isRememberMeChecked.value = !isRememberMeChecked.value;
  }

  RxBool isLoading = false.obs;
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    isLoading(true);
    final Map<String, String> requestBody = {
      'email': email,
      "password": password,
      "fcmToken": "",
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
        showSnackBar(
          title: 'Error',
          message: response.errorMessage,
          icon: Icons.error_outline_rounded,
          color: Colors.redAccent,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
