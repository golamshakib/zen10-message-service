import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling/routes/app_routes.dart';

import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../presentation/widgets/showSnacker.dart';

class SingUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();


  RxBool isLoading = false.obs;





  void signUp() async {
    final user = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPassController.text.trim();

    if (password != confirmPassword) {
      showSnackBar(
        title: 'Password Mismatch',
        message: 'Passwords do not match. Please re-enter them.',
        icon: Icons.error_outline_rounded,
        color: Colors.redAccent,
      );
      return;
    }

    isLoading(true);
    final Map<String, String> requestBody = {
      'name': user,
      "email": email,
      "password": password,
    };

    try {
      final response =
      await NetworkCaller().postRequest(AppUrls.singUp, body: requestBody);

      if (response.isSuccess) {
        String? token = response.responseData['data']['accessToken'];
        if (token != null) {
          await AuthService.saveToken(token);
        }
        showSnackBar(
          title: 'Success',
          message: 'This account is created successfully. Please Login',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );
        Get.toNamed(AppRoute.loginScreen);
      } else if (response.statusCode == 409) {
        showSnackBar(
          title: 'Same Email',
          message: 'This email is already registered',
          icon: Icons.error_outline_rounded,
          color: Colors.redAccent,
        );
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
